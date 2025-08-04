import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  
  List<UserModel> _movers = [];
  UserModel? _selectedUser;
  bool _isLoading = false;
  String? _error;

  List<UserModel> get movers => _movers;
  UserModel? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMovers() async {
    try {
      _setLoading(true);
      _clearError();
      
      _movers = await _userService.getVerifiedMovers();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserById(String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _selectedUser = await _userService.getUserById(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMoverAvailability(String moverId, bool isAvailable) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _userService.updateMoverAvailability(moverId, isAvailable);
      
      // Update local state
      final moverIndex = _movers.indexWhere((m) => m.id == moverId);
      if (moverIndex != -1) {
        _movers[moverIndex] = _movers[moverIndex].copyWith(
          isAvailable: isAvailable,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> submitMoverVerification({
    required String moverId,
    required String ghanaCardUrl,
    required String driverLicenseUrl,
    String? vehicleInfo,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _userService.submitMoverVerification(
        moverId: moverId,
        ghanaCardUrl: ghanaCardUrl,
        driverLicenseUrl: driverLicenseUrl,
        vehicleInfo: vehicleInfo,
      );
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMoverRating({
    required String moverId,
    required double rating,
  }) async {
    try {
      await _userService.updateMoverRating(
        moverId: moverId,
        rating: rating,
      );
      
      // Update local state
      final moverIndex = _movers.indexWhere((m) => m.id == moverId);
      if (moverIndex != -1) {
        final currentMover = _movers[moverIndex];
        final currentRating = currentMover.rating ?? 0.0;
        final currentTotal = currentMover.totalRatings ?? 0;
        
        final newTotal = currentTotal + 1;
        final newRating = ((currentRating * currentTotal) + rating) / newTotal;
        
        _movers[moverIndex] = currentMover.copyWith(
          rating: newRating,
          totalRatings: newTotal,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  List<UserModel> getAvailableMovers() {
    return _movers.where((mover) => 
      mover.verificationStatus == VerificationStatus.verified &&
      mover.isAvailable == true
    ).toList();
  }

  List<UserModel> searchMovers(String query) {
    if (query.isEmpty) return getAvailableMovers();
    
    final lowercaseQuery = query.toLowerCase();
    return getAvailableMovers().where((mover) =>
      mover.fullName.toLowerCase().contains(lowercaseQuery) ||
      mover.address?.toLowerCase().contains(lowercaseQuery) == true ||
      mover.services?.any((service) => 
        service.toLowerCase().contains(lowercaseQuery)
      ) == true
    ).toList();
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

  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }
}