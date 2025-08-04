import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isEmailVerified => _user?.isEmailVerified ?? false;

  AuthProvider() {
    _initializeAuth();
  }

  // Initialize authentication state
  void _initializeAuth() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        try {
          UserModel? userData = await _authService.getUserData(firebaseUser.uid);
          _user = userData;
        } catch (e) {
          _errorMessage = e.toString();
        }
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Register with email and password
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String userType,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      UserModel? user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        userType: userType,
      );

      if (user != null) {
        _user = user;
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      UserModel? user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        _user = user;
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _user = null;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.sendEmailVerification();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check email verification status
  Future<bool> checkEmailVerification() async {
    try {
      bool isVerified = await _authService.checkEmailVerified();
      if (isVerified && _user != null) {
        _user = _user!.copyWith(isEmailVerified: true);
        notifyListeners();
      }
      return isVerified;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user data
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _setError(null);
      
      if (_user != null) {
        await _authService.updateUserData(_user!.uid, data);
        
        // Update local user data
        _user = _user!.copyWith(
          firstName: data['firstName'] ?? _user!.firstName,
          lastName: data['lastName'] ?? _user!.lastName,
          phoneNumber: data['phoneNumber'] ?? _user!.phoneNumber,
          profileImageUrl: data['profileImageUrl'] ?? _user!.profileImageUrl,
          address: data['address'] ?? _user!.address,
          city: data['city'] ?? _user!.city,
          region: data['region'] ?? _user!.region,
        );
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update mover verification data
  Future<bool> updateMoverVerification({
    String? ghanaCardNumber,
    String? driverLicenseNumber,
    String? ghanaCardImageUrl,
    String? driverLicenseImageUrl,
    String? businessName,
    String? businessDescription,
    List<String>? serviceAreas,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      
      if (_user != null && _user!.isMover) {
        Map<String, dynamic> updateData = {};
        
        if (ghanaCardNumber != null) updateData['ghanaCardNumber'] = ghanaCardNumber;
        if (driverLicenseNumber != null) updateData['driverLicenseNumber'] = driverLicenseNumber;
        if (ghanaCardImageUrl != null) updateData['ghanaCardImageUrl'] = ghanaCardImageUrl;
        if (driverLicenseImageUrl != null) updateData['driverLicenseImageUrl'] = driverLicenseImageUrl;
        if (businessName != null) updateData['businessName'] = businessName;
        if (businessDescription != null) updateData['businessDescription'] = businessDescription;
        if (serviceAreas != null) updateData['serviceAreas'] = serviceAreas;
        
        await _authService.updateUserData(_user!.uid, updateData);
        
        // Update local user data
        _user = _user!.copyWith(
          ghanaCardNumber: ghanaCardNumber ?? _user!.ghanaCardNumber,
          driverLicenseNumber: driverLicenseNumber ?? _user!.driverLicenseNumber,
          ghanaCardImageUrl: ghanaCardImageUrl ?? _user!.ghanaCardImageUrl,
          driverLicenseImageUrl: driverLicenseImageUrl ?? _user!.driverLicenseImageUrl,
          businessName: businessName ?? _user!.businessName,
          businessDescription: businessDescription ?? _user!.businessDescription,
          serviceAreas: serviceAreas ?? _user!.serviceAreas,
          verificationStatus: 'pending',
        );
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update mover availability
  Future<bool> updateMoverAvailability(bool isAvailable) async {
    try {
      if (_user != null && _user!.isMover) {
        await _authService.updateUserData(_user!.uid, {
          'isAvailable': isAvailable,
        });
        
        _user = _user!.copyWith(isAvailable: isAvailable);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Delete account
  Future<bool> deleteAccount(String password) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.deleteAccount(password);
      _user = null;
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    try {
      if (_user != null) {
        UserModel? updatedUser = await _authService.getUserData(_user!.uid);
        if (updatedUser != null) {
          _user = updatedUser;
          notifyListeners();
        }
      }
    } catch (e) {
      _setError(e.toString());
    }
  }
}