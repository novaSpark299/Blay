import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _loadUserModel();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserModel() async {
    if (_user == null) return;
    
    try {
      _userModel = await _userService.getUserById(_user!.uid);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await _authService.signOut();
        _setError('Please verify your email before signing in.');
        return false;
      }
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required UserType userType,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      final userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user != null) {
        // Send email verification
        await userCredential.user!.sendEmailVerification();
        
        // Create user profile
        final userModel = UserModel(
          id: userCredential.user!.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          userType: userType,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          verificationStatus: userType == UserType.mover 
              ? VerificationStatus.pending 
              : null,
          isAvailable: userType == UserType.mover ? false : null,
        );
        
        await _userService.createUser(userModel);
        
        // Sign out user until email is verified
        await _authService.signOut();
        
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

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _userModel = null;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendEmailVerification() async {
    try {
      if (_user != null && !_user!.emailVerified) {
        await _user!.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      if (_user != null) {
        await _user!.reload();
        _user = FirebaseAuth.instance.currentUser;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    String? bio,
    List<String>? services,
    String? vehicleInfo,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (_userModel == null) return false;
      
      final updatedUser = _userModel!.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        bio: bio,
        services: services,
        vehicleInfo: vehicleInfo,
        address: address,
        latitude: latitude,
        longitude: longitude,
        updatedAt: DateTime.now(),
      );
      
      await _userService.updateUser(updatedUser);
      _userModel = updatedUser;
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
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
}