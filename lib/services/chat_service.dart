import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _chatsCollection = 'chats';
  final String _messagesCollection = 'messages';
  
  StreamSubscription<QuerySnapshot>? _chatSubscription;
  StreamSubscription<QuerySnapshot>? _messageSubscription;

  Future<ChatModel?> createOrGetChat({
    required String requestId,
    required String clientId,
    required String moverId,
  }) async {
    // Check if chat already exists
    final existingChat = await _firestore
        .collection(_chatsCollection)
        .where('requestId', isEqualTo: requestId)
        .where('clientId', isEqualTo: clientId)
        .where('moverId', isEqualTo: moverId)
        .get();

    if (existingChat.docs.isNotEmpty) {
      return ChatModel.fromFirestore(existingChat.docs.first);
    }

    // Create new chat
    final chatData = {
      'requestId': requestId,
      'clientId': clientId,
      'moverId': moverId,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      'unreadCounts': {clientId: 0, moverId: 0},
    };

    final docRef = await _firestore.collection(_chatsCollection).add(chatData);
    final doc = await docRef.get();
    return ChatModel.fromFirestore(doc);
  }

  Future<List<ChatModel>> getUserChats(String userId) async {
    final query = await _firestore
        .collection(_chatsCollection)
        .where('clientId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .get();

    final moverQuery = await _firestore
        .collection(_chatsCollection)
        .where('moverId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .get();

    final allDocs = [...query.docs, ...moverQuery.docs];
    allDocs.sort((a, b) {
      final aTime = (a.data()['updatedAt'] as Timestamp).toDate();
      final bTime = (b.data()['updatedAt'] as Timestamp).toDate();
      return bTime.compareTo(aTime);
    });

    return allDocs.map((doc) => ChatModel.fromFirestore(doc)).toList();
  }

  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final query = await _firestore
        .collection(_messagesCollection)
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .get();

    return query.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
  }

  Future<void> sendMessage(MessageModel message) async {
    final batch = _firestore.batch();

    // Add message
    final messageRef = _firestore.collection(_messagesCollection).doc();
    batch.set(messageRef, message.toFirestore());

    // Update chat with last message and increment unread count
    final chatRef = _firestore.collection(_chatsCollection).doc(message.chatId);
    final chatDoc = await chatRef.get();
    
    if (chatDoc.exists) {
      final chatData = chatDoc.data() as Map<String, dynamic>;
      final unreadCounts = Map<String, int>.from(chatData['unreadCounts'] ?? {});
      
      // Increment unread count for the recipient
      final clientId = chatData['clientId'] as String;
      final moverId = chatData['moverId'] as String;
      final recipientId = message.senderId == clientId ? moverId : clientId;
      
      unreadCounts[recipientId] = (unreadCounts[recipientId] ?? 0) + 1;

      batch.update(chatRef, {
        'lastMessage': message.toFirestore(),
        'updatedAt': Timestamp.now(),
        'unreadCounts': unreadCounts,
      });
    }

    await batch.commit();
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final batch = _firestore.batch();

    // Mark unread messages as read
    final messagesQuery = await _firestore
        .collection(_messagesCollection)
        .where('chatId', isEqualTo: chatId)
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in messagesQuery.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    // Reset unread count for this user
    final chatRef = _firestore.collection(_chatsCollection).doc(chatId);
    final chatDoc = await chatRef.get();
    
    if (chatDoc.exists) {
      final chatData = chatDoc.data() as Map<String, dynamic>;
      final unreadCounts = Map<String, int>.from(chatData['unreadCounts'] ?? {});
      unreadCounts[userId] = 0;

      batch.update(chatRef, {'unreadCounts': unreadCounts});
    }

    await batch.commit();
  }

  void subscribeToChat(String chatId, Function(List<MessageModel>) onMessagesChanged) {
    _messageSubscription?.cancel();
    _messageSubscription = _firestore
        .collection(_messagesCollection)
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
      onMessagesChanged(messages);
    });
  }

  void subscribeToUserChats(String userId, Function(List<ChatModel>) onChatsChanged) {
    _chatSubscription?.cancel();
    
    // This is a simplified version - in production, you might want to use a composite query
    _chatSubscription = _firestore
        .collection(_chatsCollection)
        .where('clientId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) async {
      // Also get chats where user is a mover
      final moverSnapshot = await _firestore
          .collection(_chatsCollection)
          .where('moverId', isEqualTo: userId)
          .get();

      final allDocs = [...snapshot.docs, ...moverSnapshot.docs];
      allDocs.sort((a, b) {
        final aTime = (a.data()['updatedAt'] as Timestamp).toDate();
        final bTime = (b.data()['updatedAt'] as Timestamp).toDate();
        return bTime.compareTo(aTime);
      });

      final chats = allDocs.map((doc) => ChatModel.fromFirestore(doc)).toList();
      onChatsChanged(chats);
    });
  }

  void unsubscribeFromChat() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }

  void unsubscribeFromUserChats() {
    _chatSubscription?.cancel();
    _chatSubscription = null;
  }
}