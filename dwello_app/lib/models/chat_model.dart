import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String requestId;
  final String clientId;
  final String moverId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final int unreadCountClient;
  final int unreadCountMover;
  final bool isActive;

  ChatModel({
    required this.id,
    required this.requestId,
    required this.clientId,
    required this.moverId,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.unreadCountClient = 0,
    this.unreadCountMover = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestId': requestId,
      'clientId': clientId,
      'moverId': moverId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCountClient': unreadCountClient,
      'unreadCountMover': unreadCountMover,
      'isActive': isActive,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      requestId: map['requestId'] ?? '',
      clientId: map['clientId'] ?? '',
      moverId: map['moverId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: map['lastMessage'],
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate(),
      lastMessageSenderId: map['lastMessageSenderId'],
      unreadCountClient: map['unreadCountClient'] ?? 0,
      unreadCountMover: map['unreadCountMover'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  ChatModel copyWith({
    String? id,
    String? requestId,
    String? clientId,
    String? moverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    int? unreadCountClient,
    int? unreadCountMover,
    bool? isActive,
  }) {
    return ChatModel(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      clientId: clientId ?? this.clientId,
      moverId: moverId ?? this.moverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCountClient: unreadCountClient ?? this.unreadCountClient,
      unreadCountMover: unreadCountMover ?? this.unreadCountMover,
      isActive: isActive ?? this.isActive,
    );
  }
}

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String content;
  final String messageType; // 'text', 'image', 'location', 'file'
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.messageType,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.fileUrl,
    this.fileName,
    this.fileSize,
  });

  bool get isTextMessage => messageType == 'text';
  bool get isImageMessage => messageType == 'image';
  bool get isLocationMessage => messageType == 'location';
  bool get isFileMessage => messageType == 'file';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'messageType': messageType,
      'timestamp': timestamp,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileSize': fileSize,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      messageType: map['messageType'] ?? 'text',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      fileUrl: map['fileUrl'],
      fileName: map['fileName'],
      fileSize: map['fileSize'],
    );
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? content,
    String? messageType,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? fileUrl,
    String? fileName,
    int? fileSize,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}