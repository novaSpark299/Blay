# Dwello - Mobile Platform for Structured Relocation Services in Ghana

Dwello is a comprehensive mobile application designed to bridge the gap between clients and professional movers in Ghana's relocation industry. The app provides a digital platform where clients can interact with verified movers, submit relocation requests, communicate through in-app chat, and track service progress in real-time.

## 🚀 Features

### General Features
- **SplashScreen**: Beautiful animated splash screen with app branding
- **LoginScreen**: Secure email/password authentication
- **RegisterScreen**: User registration for both clients and movers
- **EmailVerificationScreen**: Email verification process
- **SettingsScreen**: App settings and preferences
- **EditProfileScreen**: User profile management
- **UserProfileScreen**: View user profiles

### Client Features
- **ClientDashboardScreen**: Overview of requests and services
- **CreateRequestScreen**: Submit new relocation requests
- **ClientRequestsScreen**: View and manage submitted requests
- **RequestDetailsScreen**: Detailed view of specific requests
- **ChatListScreen**: List of all chat conversations
- **ChatScreen**: Real-time messaging with movers
- **RateMoverScreen**: Rate and review mover services
- **TrackRequestScreen**: Real-time tracking of ongoing requests

### Mover Features
- **MoverDashboardScreen**: Dashboard for managing services
- **MoverVerificationScreen**: Upload Ghana Card & Driver's License
- **VerificationPendingScreen**: Status of verification process
- **AvailableRequestsScreen**: Browse available relocation requests
- **AcceptedRequestsScreen**: Manage accepted requests
- **RequestDetailsScreen**: View request details
- **UpdateRequestStatusScreen**: Update job progress
- **ChatScreen**: Communicate with clients
- **RateClientScreen**: Rate client interactions
- **LocationSharingScreen**: Share real-time location

## 🛠 Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Authentication: Email/password + Email verification
  - Database: Firestore for user profiles, requests, and chat data
  - Storage: Firebase Storage for documents and images
  - Messaging: Real-time chat with Firestore streams
- **State Management**: Provider
- **Maps & Location**: Google Maps Flutter, Geolocator
- **UI/UX**: Material Design with custom theming

## 📱 App Architecture

```
lib/
├── constants/          # App constants and configuration
├── models/            # Data models (User, Request, Chat, Message)
├── services/          # Firebase services (Auth, Firestore, Storage)
├── providers/         # State management with Provider
├── screens/           # UI screens organized by feature
│   ├── auth/         # Authentication screens
│   ├── client/       # Client-specific screens
│   ├── mover/        # Mover-specific screens
│   └── shared/       # Shared screens
├── widgets/          # Reusable UI components
└── utils/            # Utility functions and helpers
```

## 🔧 Firebase Services

### Authentication
- Email/password registration and login
- Email verification
- Password reset functionality
- User session management

### Firestore Collections
- **users**: User profiles and verification status
- **requests**: Relocation requests and tracking
- **chats**: Chat conversations between clients and movers
- **messages**: Individual chat messages
- **ratings**: User ratings and reviews

### Storage
- **verification_documents/**: Ghana Card and Driver's License uploads
- **profile_images/**: User profile pictures
- **chat_images/**: Images shared in conversations
- **request_images/**: Photos related to relocation requests

## 📋 Key Models

### UserModel
- Personal information (name, email, phone)
- User type (client/mover)
- Mover verification documents
- Location and availability status
- Ratings and completed jobs

### RequestModel
- Request details and requirements
- Pickup and delivery locations
- Status tracking and updates
- Pricing information
- Associated chat and mover

### ChatModel & MessageModel
- Real-time messaging between clients and movers
- Support for text, images, and location sharing
- Read receipts and message status

## 🎨 Design System

### Colors
- **Primary**: Green (#2E7D32) - Trust and reliability
- **Secondary**: Light Green (#4CAF50) - Growth and success
- **Accent**: Orange (#FF9800) - Energy and action
- **Background**: Light Grey (#F5F5F5) - Clean and modern

### Typography
- **Font Family**: Poppins (Google Fonts)
- **Heading**: Bold, 24px
- **Body**: Regular, 16px
- **Caption**: Medium, 14px

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.24.5 or later)
- Dart SDK (3.5.4 or later)
- Firebase project setup
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dwello_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Enable Firebase Storage
   - Update `lib/firebase_options.dart` with your project configuration

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Configuration

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project configuration:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: 'your-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-storage-bucket',
);
```

## 📊 Development Status

### ✅ Completed
- [x] Project structure and architecture
- [x] Firebase services integration
- [x] Data models and constants
- [x] Authentication provider
- [x] Splash screen with animations
- [x] Login screen with validation
- [x] Custom UI components
- [x] App theming and design system

### 🚧 In Progress
- [ ] Registration screen implementation
- [ ] Email verification flow
- [ ] Client dashboard and features
- [ ] Mover dashboard and features
- [ ] Real-time chat system

### 📋 Planned
- [ ] Request creation and management
- [ ] Mover verification process
- [ ] Real-time location tracking
- [ ] Rating and review system
- [ ] Push notifications
- [ ] Advanced search and filtering

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions, please contact:
- Email: support@dwello.com
- Website: https://dwello.com

---

**Dwello** - Your trusted relocation partner in Ghana 🇬🇭
