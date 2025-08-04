import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  Future<void> createUser(UserModel user) async {
    await _firestore.collection(_collection).doc(user.id).set(user.toFirestore());
  }

  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestore.collection(_collection).doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection(_collection).doc(user.id).update(user.toFirestore());
  }

  Future<List<UserModel>> getVerifiedMovers() async {
    final query = await _firestore
        .collection(_collection)
        .where('userType', isEqualTo: 'mover')
        .where('verificationStatus', isEqualTo: 'verified')
        .get();

    return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  Future<void> updateMoverAvailability(String moverId, bool isAvailable) async {
    await _firestore.collection(_collection).doc(moverId).update({
      'isAvailable': isAvailable,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> submitMoverVerification({
    required String moverId,
    required String ghanaCardUrl,
    required String driverLicenseUrl,
    String? vehicleInfo,
  }) async {
    await _firestore.collection(_collection).doc(moverId).update({
      'ghanaCardUrl': ghanaCardUrl,
      'driverLicenseUrl': driverLicenseUrl,
      'vehicleInfo': vehicleInfo,
      'verificationStatus': 'pending',
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> updateMoverRating({
    required String moverId,
    required double rating,
  }) async {
    final userDoc = await _firestore.collection(_collection).doc(moverId).get();
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final currentRating = userData['rating']?.toDouble() ?? 0.0;
      final currentTotal = userData['totalRatings'] ?? 0;
      
      final newTotal = currentTotal + 1;
      final newRating = ((currentRating * currentTotal) + rating) / newTotal;
      
      await _firestore.collection(_collection).doc(moverId).update({
        'rating': newRating,
        'totalRatings': newTotal,
        'updatedAt': Timestamp.now(),
      });
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  Stream<List<UserModel>> getAvailableMoversStream() {
    return _firestore
        .collection(_collection)
        .where('userType', isEqualTo: 'mover')
        .where('verificationStatus', isEqualTo: 'verified')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((query) => query.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }
}