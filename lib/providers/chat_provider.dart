import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  ChatModel? _currentChat;
  bool _isLoading = false;
  String? _error;

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  ChatModel? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserChats(String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _chats = await _chatService.getUserChats(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadChatMessages(String chatId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _messages = await _chatService.getChatMessages(chatId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<ChatModel?> createOrGetChat({
    required String requestId,
    required String clientId,
    required String moverId,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      final chat = await _chatService.createOrGetChat(
        requestId: requestId,
        clientId: clientId,
        moverId: moverId,
      );
      
      if (chat != null) {
        _currentChat = chat;
        
        // Add to chats list if not already present
        final existingIndex = _chats.indexWhere((c) => c.id == chat.id);
        if (existingIndex == -1) {
          _chats.insert(0, chat);
        } else {
          _chats[existingIndex] = chat;
        }
        
        notifyListeners();
      }
      
      return chat;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final message = MessageModel(
        id: '', // Will be set by Firestore
        chatId: chatId,
        senderId: senderId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
        imageUrl: imageUrl,
        latitude: latitude,
        longitude: longitude,
      );
      
      await _chatService.sendMessage(message);
      
      // Add message to local list
      _messages.add(message);
      
      // Update current chat's last message
      if (_currentChat?.id == chatId) {
        _currentChat = _currentChat!.copyWith(
          lastMessage: message,
          updatedAt: DateTime.now(),
        );
      }
      
      // Update chat in chats list
      final chatIndex = _chats.indexWhere((c) => c.id == chatId);
      if (chatIndex != -1) {
        _chats[chatIndex] = _chats[chatIndex].copyWith(
          lastMessage: message,
          updatedAt: DateTime.now(),
        );
        
        // Move chat to top of list
        final updatedChat = _chats.removeAt(chatIndex);
        _chats.insert(0, updatedChat);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      await _chatService.markMessagesAsRead(chatId, userId);
      
      // Update local messages
      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i].senderId != userId && !_messages[i].isRead) {
          _messages[i] = _messages[i].copyWith(isRead: true);
        }
      }
      
      // Update unread count in current chat
      if (_currentChat?.id == chatId) {
        final updatedUnreadCounts = Map<String, int>.from(_currentChat!.unreadCounts);
        updatedUnreadCounts[userId] = 0;
        _currentChat = _currentChat!.copyWith(unreadCounts: updatedUnreadCounts);
      }
      
      // Update unread count in chats list
      final chatIndex = _chats.indexWhere((c) => c.id == chatId);
      if (chatIndex != -1) {
        final updatedUnreadCounts = Map<String, int>.from(_chats[chatIndex].unreadCounts);
        updatedUnreadCounts[userId] = 0;
        _chats[chatIndex] = _chats[chatIndex].copyWith(unreadCounts: updatedUnreadCounts);
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  void subscribeToChat(String chatId) {
    _chatService.subscribeToChat(chatId, (messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  void subscribeToUserChats(String userId) {
    _chatService.subscribeToUserChats(userId, (chats) {
      _chats = chats;
      notifyListeners();
    });
  }

  void unsubscribeFromChat() {
    _chatService.unsubscribeFromChat();
  }

  void unsubscribeFromUserChats() {
    _chatService.unsubscribeFromUserChats();
  }

  int getTotalUnreadCount(String userId) {
    return _chats.fold(0, (total, chat) => total + chat.getUnreadCount(userId));
  }

  void setCurrentChat(ChatModel? chat) {
    _currentChat = chat;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    unsubscribeFromChat();
    unsubscribeFromUserChats();
    super.dispose();
  }
}