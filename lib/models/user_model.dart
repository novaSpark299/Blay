import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { client, mover }

enum VerificationStatus { pending, verified, rejected }

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final UserType userType;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Mover specific fields
  final VerificationStatus? verificationStatus;
  final String? ghanaCardUrl;
  final String? driverLicenseUrl;
  final String? vehicleInfo;
  final double? rating;
  final int? totalRatings;
  final bool? isAvailable;
  final String? bio;
  final List<String>? services;
  
  // Location
  final double? latitude;
  final double? longitude;
  final String? address;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.userType,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.verificationStatus,
    this.ghanaCardUrl,
    this.driverLicenseUrl,
    this.vehicleInfo,
    this.rating,
    this.totalRatings,
    this.isAvailable,
    this.bio,
    this.services,
    this.latitude,
    this.longitude,
    this.address,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      userType: UserType.values.firstWhere(
        (type) => type.toString().split('.').last == data['userType'],
        orElse: () => UserType.client,
      ),
      profileImageUrl: data['profileImageUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      verificationStatus: data['verificationStatus'] != null
          ? VerificationStatus.values.firstWhere(
              (status) => status.toString().split('.').last == data['verificationStatus'],
              orElse: () => VerificationStatus.pending,
            )
          : null,
      ghanaCardUrl: data['ghanaCardUrl'],
      driverLicenseUrl: data['driverLicenseUrl'],
      vehicleInfo: data['vehicleInfo'],
      rating: data['rating']?.toDouble(),
      totalRatings: data['totalRatings'],
      isAvailable: data['isAvailable'],
      bio: data['bio'],
      services: data['services'] != null ? List<String>.from(data['services']) : null,
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      address: data['address'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userType': userType.toString().split('.').last,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (verificationStatus != null)
        'verificationStatus': verificationStatus.toString().split('.').last,
      'ghanaCardUrl': ghanaCardUrl,
      'driverLicenseUrl': driverLicenseUrl,
      'vehicleInfo': vehicleInfo,
      'rating': rating,
      'totalRatings': totalRatings,
      'isAvailable': isAvailable,
      'bio': bio,
      'services': services,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  UserModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    UserType? userType,
    String? profileImageUrl,
    DateTime? updatedAt,
    VerificationStatus? verificationStatus,
    String? ghanaCardUrl,
    String? driverLicenseUrl,
    String? vehicleInfo,
    double? rating,
    int? totalRatings,
    bool? isAvailable,
    String? bio,
    List<String>? services,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      verificationStatus: verificationStatus ?? this.verificationStatus,
      ghanaCardUrl: ghanaCardUrl ?? this.ghanaCardUrl,
      driverLicenseUrl: driverLicenseUrl ?? this.driverLicenseUrl,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      isAvailable: isAvailable ?? this.isAvailable,
      bio: bio ?? this.bio,
      services: services ?? this.services,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}