import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/request_model.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // REQUESTS OPERATIONS

  // Create a new request
  Future<String> createRequest(RequestModel request) async {
    try {
      String requestId = _uuid.v4();
      RequestModel newRequest = request.copyWith(
        id: requestId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: AppConstants.requestStatusPending,
      );

      await _firestore
          .collection(AppConstants.requestsCollection)
          .doc(requestId)
          .set(newRequest.toMap());

      return requestId;
    } catch (e) {
      throw Exception('Failed to create request: ${e.toString()}');
    }
  }

  // Get request by ID
  Future<RequestModel?> getRequest(String requestId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.requestsCollection)
          .doc(requestId)
          .get();

      if (doc.exists) {
        return RequestModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get request: ${e.toString()}');
    }
  }

  // Get requests for a client
  Stream<List<RequestModel>> getClientRequests(String clientId) {
    return _firestore
        .collection(AppConstants.requestsCollection)
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RequestModel.fromMap(doc.data()))
            .toList());
  }

  // Get requests for a mover
  Stream<List<RequestModel>> getMoverRequests(String moverId) {
    return _firestore
        .collection(AppConstants.requestsCollection)
        .where('moverId', isEqualTo: moverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RequestModel.fromMap(doc.data()))
            .toList());
  }

  // Get available requests (pending requests without assigned mover)
  Stream<List<RequestModel>> getAvailableRequests() {
    return _firestore
        .collection(AppConstants.requestsCollection)
        .where('status', isEqualTo: AppConstants.requestStatusPending)
        .where('moverId', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RequestModel.fromMap(doc.data()))
            .toList());
  }

  // Update request status
  Future<void> updateRequestStatus(
    String requestId,
    String status, {
    String? message,
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'status': status,
        'updatedAt': DateTime.now(),
      };

      // Get current request to add update to history
      RequestModel? request = await getRequest(requestId);
      if (request != null) {
        List<RequestUpdate> updates = List.from(request.updates);
        updates.add(RequestUpdate(
          status: status,
          message: message ?? 'Status updated to $status',
          timestamp: DateTime.now(),
          location: location,
          latitude: latitude,
          longitude: longitude,
        ));
        updateData['updates'] = updates.map((u) => u.toMap()).toList();
      }

      await _firestore
          .collection(AppConstants.requestsCollection)
          .doc(requestId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update request status: ${e.toString()}');
    }
  }

  // Assign mover to request
  Future<void> assignMoverToRequest(String requestId, String moverId) async {
    try {
      await _firestore
          .collection(AppConstants.requestsCollection)
          .doc(requestId)
          .update({
        'moverId': moverId,
        'status': AppConstants.requestStatusAccepted,
        'updatedAt': DateTime.now(),
      });

      // Create chat for the request
      await createChat(requestId, moverId);
    } catch (e) {
      throw Exception('Failed to assign mover: ${e.toString()}');
    }
  }

  // Update request price
  Future<void> updateRequestPrice(
    String requestId, {
    double? estimatedPrice,
    double? finalPrice,
  }) async {
    try {
      Map<String, dynamic> updateData = {'updatedAt': DateTime.now()};
      
      if (estimatedPrice != null) {
        updateData['estimatedPrice'] = estimatedPrice;
      }
      if (finalPrice != null) {
        updateData['finalPrice'] = finalPrice;
      }

      await _firestore
          .collection(AppConstants.requestsCollection)
          .doc(requestId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update request price: ${e.toString()}');
    }
  }

  // USER OPERATIONS

  // Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // Update mover verification documents
  Future<void> updateMoverVerification(
    String moverId, {
    String? ghanaCardNumber,
    String? driverLicenseNumber,
    String? ghanaCardImageUrl,
    String? driverLicenseImageUrl,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': DateTime.now(),
        'verificationStatus': AppConstants.verificationStatusPending,
      };

      if (ghanaCardNumber != null) {
        updateData['ghanaCardNumber'] = ghanaCardNumber;
      }
      if (driverLicenseNumber != null) {
        updateData['driverLicenseNumber'] = driverLicenseNumber;
      }
      if (ghanaCardImageUrl != null) {
        updateData['ghanaCardImageUrl'] = ghanaCardImageUrl;
      }
      if (driverLicenseImageUrl != null) {
        updateData['driverLicenseImageUrl'] = driverLicenseImageUrl;
      }

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(moverId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update mover verification: ${e.toString()}');
    }
  }

  // Get verified movers
  Stream<List<UserModel>> getVerifiedMovers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('userType', isEqualTo: AppConstants.userTypeMover)
        .where('verificationStatus', isEqualTo: AppConstants.verificationStatusApproved)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList());
  }

  // Update mover availability
  Future<void> updateMoverAvailability(String moverId, bool isAvailable) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(moverId)
          .update({
        'isAvailable': isAvailable,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to update mover availability: ${e.toString()}');
    }
  }

  // Update mover location
  Future<void> updateMoverLocation(
    String moverId,
    double latitude,
    double longitude, {
    String? address,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'latitude': latitude,
        'longitude': longitude,
        'updatedAt': DateTime.now(),
      };

      if (address != null) {
        updateData['address'] = address;
      }

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(moverId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update mover location: ${e.toString()}');
    }
  }

  // CHAT OPERATIONS

  // Create chat
  Future<String> createChat(String requestId, String moverId) async {
    try {
      // Get request to get client ID
      RequestModel? request = await getRequest(requestId);
      if (request == null) {
        throw Exception('Request not found');
      }

      String chatId = _uuid.v4();
      ChatModel chat = ChatModel(
        id: chatId,
        requestId: requestId,
        clientId: request.clientId,
        moverId: moverId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .set(chat.toMap());

      // Update request with chat ID
      await _firestore
          .collection(AppConstants.requestsCollection)
          .doc(requestId)
          .update({'chatId': chatId});

      return chatId;
    } catch (e) {
      throw Exception('Failed to create chat: ${e.toString()}');
    }
  }

  // Get chat by ID
  Future<ChatModel?> getChat(String chatId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .get();

      if (doc.exists) {
        return ChatModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get chat: ${e.toString()}');
    }
  }

  // Get chats for user
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) {
              final data = doc.data();
              return data['clientId'] == userId || data['moverId'] == userId;
            })
            .map((doc) => ChatModel.fromMap(doc.data()))
            .toList());
  }

  // Send message
  Future<void> sendMessage(MessageModel message) async {
    try {
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(message.chatId)
          .collection(AppConstants.messagesCollection)
          .doc(message.id)
          .set(message.toMap());

      // Update chat with last message info
      await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(message.chatId)
          .update({
        'lastMessage': message.content,
        'lastMessageTime': message.timestamp,
        'lastMessageSenderId': message.senderId,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  // Get messages for chat
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection(AppConstants.chatsCollection)
        .doc(chatId)
        .collection(AppConstants.messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      QuerySnapshot unreadMessages = await _firestore
          .collection(AppConstants.chatsCollection)
          .doc(chatId)
          .collection(AppConstants.messagesCollection)
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      WriteBatch batch = _firestore.batch();
      for (QueryDocumentSnapshot doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark messages as read: ${e.toString()}');
    }
  }

  // RATINGS OPERATIONS

  // Add rating
  Future<void> addRating({
    required String raterId,
    required String ratedUserId,
    required String requestId,
    required double rating,
    String? comment,
  }) async {
    try {
      String ratingId = _uuid.v4();
      await _firestore
          .collection(AppConstants.ratingsCollection)
          .doc(ratingId)
          .set({
        'id': ratingId,
        'raterId': raterId,
        'ratedUserId': ratedUserId,
        'requestId': requestId,
        'rating': rating,
        'comment': comment,
        'createdAt': DateTime.now(),
      });

      // Update user's average rating
      await _updateUserRating(ratedUserId);
    } catch (e) {
      throw Exception('Failed to add rating: ${e.toString()}');
    }
  }

  // Update user's average rating
  Future<void> _updateUserRating(String userId) async {
    try {
      QuerySnapshot ratings = await _firestore
          .collection(AppConstants.ratingsCollection)
          .where('ratedUserId', isEqualTo: userId)
          .get();

      if (ratings.docs.isNotEmpty) {
        double totalRating = 0;
        for (QueryDocumentSnapshot doc in ratings.docs) {
          totalRating += (doc.data() as Map<String, dynamic>)['rating'];
        }
        double averageRating = totalRating / ratings.docs.length;

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({
          'rating': double.parse(averageRating.toStringAsFixed(1)),
          'updatedAt': DateTime.now(),
        });
      }
    } catch (e) {
      throw Exception('Failed to update user rating: ${e.toString()}');
    }
  }

  // Get user ratings
  Stream<List<Map<String, dynamic>>> getUserRatings(String userId) {
    return _firestore
        .collection(AppConstants.ratingsCollection)
        .where('ratedUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data())
            .toList());
  }
}