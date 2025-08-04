import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Dwello';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your trusted relocation partner in Ghana';

  // Colors
  static const Color primaryColor = Color(0xFF2E7D32); // Green
  static const Color secondaryColor = Color(0xFF4CAF50); // Light Green
  static const Color accentColor = Color(0xFFFF9800); // Orange
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color warningColor = Color(0xFFFF9800); // Orange
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light Grey
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color textPrimaryColor = Color(0xFF212121); // Dark Grey
  static const Color textSecondaryColor = Color(0xFF757575); // Medium Grey
  static const Color dividerColor = Color(0xFFE0E0E0); // Light Grey

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
  );

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Request Status
  static const String requestStatusPending = 'pending';
  static const String requestStatusAccepted = 'accepted';
  static const String requestStatusInProgress = 'in_progress';
  static const String requestStatusCompleted = 'completed';
  static const String requestStatusCancelled = 'cancelled';

  // User Types
  static const String userTypeClient = 'client';
  static const String userTypeMover = 'mover';

  // Verification Status
  static const String verificationStatusPending = 'pending';
  static const String verificationStatusApproved = 'approved';
  static const String verificationStatusRejected = 'rejected';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String requestsCollection = 'requests';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String ratingsCollection = 'ratings';

  // Storage Paths
  static const String verificationDocsPath = 'verification_documents';
  static const String profileImagesPath = 'profile_images';
  static const String chatImagesPath = 'chat_images';

  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';
  static const String permissionDeniedMessage = 'Permission denied. Please grant necessary permissions.';

  // Success Messages
  static const String registrationSuccessMessage = 'Registration successful! Please verify your email.';
  static const String loginSuccessMessage = 'Welcome back!';
  static const String requestSubmittedMessage = 'Your request has been submitted successfully.';
  static const String profileUpdatedMessage = 'Profile updated successfully.';
}