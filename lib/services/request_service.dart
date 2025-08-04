import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'requests';

  Future<String?> createRequest(RequestModel request) async {
    final docRef = await _firestore.collection(_collection).add(request.toFirestore());
    return docRef.id;
  }

  Future<RequestModel?> getRequestById(String requestId) async {
    final doc = await _firestore.collection(_collection).doc(requestId).get();
    if (doc.exists) {
      return RequestModel.fromFirestore(doc);
    }
    return null;
  }

  Future<List<RequestModel>> getClientRequests(String clientId) async {
    final query = await _firestore
        .collection(_collection)
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((doc) => RequestModel.fromFirestore(doc)).toList();
  }

  Future<List<RequestModel>> getMoverRequests(String moverId) async {
    final query = await _firestore
        .collection(_collection)
        .where('moverId', isEqualTo: moverId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((doc) => RequestModel.fromFirestore(doc)).toList();
  }

  Future<List<RequestModel>> getAvailableRequests() async {
    final query = await _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'pending')
        .where('moverId', isNull: true)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((doc) => RequestModel.fromFirestore(doc)).toList();
  }

  Future<void> acceptRequest(String requestId, String moverId) async {
    await _firestore.collection(_collection).doc(requestId).update({
      'moverId': moverId,
      'status': 'accepted',
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> updateRequestStatus(String requestId, RequestStatus status) async {
    await _firestore.collection(_collection).doc(requestId).update({
      'status': status.toString().split('.').last,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> cancelRequest(String requestId) async {
    await _firestore.collection(_collection).doc(requestId).update({
      'status': 'cancelled',
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> rateClient({
    required String requestId,
    required String clientId,
    required double rating,
    String? comment,
  }) async {
    await _firestore.collection(_collection).doc(requestId).update({
      'clientRating': {
        'rating': rating,
        'comment': comment,
        'ratedAt': Timestamp.now(),
      },
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> rateMover({
    required String requestId,
    required String moverId,
    required double rating,
    String? comment,
  }) async {
    await _firestore.collection(_collection).doc(requestId).update({
      'moverRating': {
        'rating': rating,
        'comment': comment,
        'ratedAt': Timestamp.now(),
      },
      'updatedAt': Timestamp.now(),
    });
  }

  Stream<RequestModel?> getRequestStream(String requestId) {
    return _firestore
        .collection(_collection)
        .doc(requestId)
        .snapshots()
        .map((doc) => doc.exists ? RequestModel.fromFirestore(doc) : null);
  }

  Stream<List<RequestModel>> getClientRequestsStream(String clientId) {
    return _firestore
        .collection(_collection)
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) => query.docs.map((doc) => RequestModel.fromFirestore(doc)).toList());
  }

  Stream<List<RequestModel>> getMoverRequestsStream(String moverId) {
    return _firestore
        .collection(_collection)
        .where('moverId', isEqualTo: moverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) => query.docs.map((doc) => RequestModel.fromFirestore(doc)).toList());
  }

  Stream<List<RequestModel>> getAvailableRequestsStream() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'pending')
        .where('moverId', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) => query.docs.map((doc) => RequestModel.fromFirestore(doc)).toList());
  }
}