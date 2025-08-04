import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/general/settings_screen.dart';
import '../screens/general/edit_profile_screen.dart';
import '../screens/general/user_profile_screen.dart';
import '../screens/client/client_dashboard_screen.dart';
import '../screens/client/create_request_screen.dart';
import '../screens/client/client_requests_screen.dart';
import '../screens/client/request_details_screen.dart';
import '../screens/client/chat_list_screen.dart';
import '../screens/client/chat_screen.dart';
import '../screens/client/rate_mover_screen.dart';
import '../screens/client/track_request_screen.dart';
import '../screens/mover/mover_dashboard_screen.dart';
import '../screens/mover/mover_verification_screen.dart';
import '../screens/mover/verification_pending_screen.dart';
import '../screens/mover/available_requests_screen.dart';
import '../screens/mover/accepted_requests_screen.dart';
import '../screens/mover/update_request_status_screen.dart';
import '../screens/mover/rate_client_screen.dart';
import '../screens/mover/location_sharing_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerification = '/email-verification';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String userProfile = '/user-profile';
  
  // Client routes
  static const String clientDashboard = '/client-dashboard';
  static const String createRequest = '/create-request';
  static const String clientRequests = '/client-requests';
  static const String requestDetails = '/request-details';
  static const String chatList = '/chat-list';
  static const String chat = '/chat';
  static const String rateMover = '/rate-mover';
  static const String trackRequest = '/track-request';
  
  // Mover routes
  static const String moverDashboard = '/mover-dashboard';
  static const String moverVerification = '/mover-verification';
  static const String verificationPending = '/verification-pending';
  static const String availableRequests = '/available-requests';
  static const String acceptedRequests = '/accepted-requests';
  static const String updateRequestStatus = '/update-request-status';
  static const String rateClient = '/rate-client';
  static const String locationSharing = '/location-sharing';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case emailVerification:
        return MaterialPageRoute(builder: (_) => const EmailVerificationScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case userProfile:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => UserProfileScreen(userId: userId),
        );
      
      // Client routes
      case clientDashboard:
        return MaterialPageRoute(builder: (_) => const ClientDashboardScreen());
      case createRequest:
        return MaterialPageRoute(builder: (_) => const CreateRequestScreen());
      case clientRequests:
        return MaterialPageRoute(builder: (_) => const ClientRequestsScreen());
      case requestDetails:
        final requestId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => RequestDetailsScreen(requestId: requestId),
        );
      case chatList:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: args['chatId'],
            recipientId: args['recipientId'],
            recipientName: args['recipientName'],
          ),
        );
      case rateMover:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RateMoverScreen(
            moverId: args['moverId'],
            requestId: args['requestId'],
          ),
        );
      case trackRequest:
        final requestId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TrackRequestScreen(requestId: requestId),
        );
      
      // Mover routes
      case moverDashboard:
        return MaterialPageRoute(builder: (_) => const MoverDashboardScreen());
      case moverVerification:
        return MaterialPageRoute(builder: (_) => const MoverVerificationScreen());
      case verificationPending:
        return MaterialPageRoute(builder: (_) => const VerificationPendingScreen());
      case availableRequests:
        return MaterialPageRoute(builder: (_) => const AvailableRequestsScreen());
      case acceptedRequests:
        return MaterialPageRoute(builder: (_) => const AcceptedRequestsScreen());
      case updateRequestStatus:
        final requestId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => UpdateRequestStatusScreen(requestId: requestId),
        );
      case rateClient:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RateClientScreen(
            clientId: args['clientId'],
            requestId: args['requestId'],
          ),
        );
      case locationSharing:
        final requestId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => LocationSharingScreen(requestId: requestId),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}