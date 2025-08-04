import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, location }

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.imageUrl,
    this.latitude,
    this.longitude,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return MessageModel(
      id: doc.id,
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] ?? '',
      content: data['content'] ?? '',
      type: MessageType.values.firstWhere(
        (type) => type.toString().split('.').last == data['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  MessageModel copyWith({
    bool? isRead,
  }) {
    return MessageModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

class ChatModel {
  final String id;
  final String requestId;
  final String clientId;
  final String moverId;
  final MessageModel? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, int> unreadCounts;

  ChatModel({
    required this.id,
    required this.requestId,
    required this.clientId,
    required this.moverId,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadCounts,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ChatModel(
      id: doc.id,
      requestId: data['requestId'] ?? '',
      clientId: data['clientId'] ?? '',
      moverId: data['moverId'] ?? '',
      lastMessage: data['lastMessage'] != null
          ? MessageModel(
              id: data['lastMessage']['id'] ?? '',
              chatId: doc.id,
              senderId: data['lastMessage']['senderId'] ?? '',
              content: data['lastMessage']['content'] ?? '',
              type: MessageType.values.firstWhere(
                (type) => type.toString().split('.').last == data['lastMessage']['type'],
                orElse: () => MessageType.text,
              ),
              timestamp: (data['lastMessage']['timestamp'] as Timestamp).toDate(),
              isRead: data['lastMessage']['isRead'] ?? false,
              imageUrl: data['lastMessage']['imageUrl'],
              latitude: data['lastMessage']['latitude']?.toDouble(),
              longitude: data['lastMessage']['longitude']?.toDouble(),
            )
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'requestId': requestId,
      'clientId': clientId,
      'moverId': moverId,
      'lastMessage': lastMessage?.toFirestore(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'unreadCounts': unreadCounts,
    };
  }

  ChatModel copyWith({
    MessageModel? lastMessage,
    DateTime? updatedAt,
    Map<String, int>? unreadCounts,
  }) {
    return ChatModel(
      id: id,
      requestId: requestId,
      clientId: clientId,
      moverId: moverId,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  String getOtherParticipantId(String currentUserId) {
    return currentUserId == clientId ? moverId : clientId;
  }

  int getUnreadCount(String userId) {
    return unreadCounts[userId] ?? 0;
  }
}