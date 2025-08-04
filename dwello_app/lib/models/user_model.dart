import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String userType; // 'client' or 'mover'
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isActive;
  
  // Mover-specific fields
  final String? ghanaCardNumber;
  final String? driverLicenseNumber;
  final String? ghanaCardImageUrl;
  final String? driverLicenseImageUrl;
  final String verificationStatus; // 'pending', 'approved', 'rejected'
  final double? rating;
  final int? completedJobs;
  final String? businessName;
  final String? businessDescription;
  final List<String>? serviceAreas;
  final bool? isAvailable;
  
  // Location
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? region;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.userType,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    this.isActive = true,
    this.ghanaCardNumber,
    this.driverLicenseNumber,
    this.ghanaCardImageUrl,
    this.driverLicenseImageUrl,
    this.verificationStatus = 'pending',
    this.rating,
    this.completedJobs = 0,
    this.businessName,
    this.businessDescription,
    this.serviceAreas,
    this.isAvailable = true,
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.region,
  });

  String get fullName => '$firstName $lastName';

  bool get isMover => userType == 'mover';
  bool get isClient => userType == 'client';
  bool get isVerified => verificationStatus == 'approved';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userType': userType,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isEmailVerified': isEmailVerified,
      'isActive': isActive,
      'ghanaCardNumber': ghanaCardNumber,
      'driverLicenseNumber': driverLicenseNumber,
      'ghanaCardImageUrl': ghanaCardImageUrl,
      'driverLicenseImageUrl': driverLicenseImageUrl,
      'verificationStatus': verificationStatus,
      'rating': rating,
      'completedJobs': completedJobs,
      'businessName': businessName,
      'businessDescription': businessDescription,
      'serviceAreas': serviceAreas,
      'isAvailable': isAvailable,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'region': region,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      userType: map['userType'] ?? 'client',
      profileImageUrl: map['profileImageUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isEmailVerified: map['isEmailVerified'] ?? false,
      isActive: map['isActive'] ?? true,
      ghanaCardNumber: map['ghanaCardNumber'],
      driverLicenseNumber: map['driverLicenseNumber'],
      ghanaCardImageUrl: map['ghanaCardImageUrl'],
      driverLicenseImageUrl: map['driverLicenseImageUrl'],
      verificationStatus: map['verificationStatus'] ?? 'pending',
      rating: map['rating']?.toDouble(),
      completedJobs: map['completedJobs'] ?? 0,
      businessName: map['businessName'],
      businessDescription: map['businessDescription'],
      serviceAreas: List<String>.from(map['serviceAreas'] ?? []),
      isAvailable: map['isAvailable'] ?? true,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      address: map['address'],
      city: map['city'],
      region: map['region'],
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? userType,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isActive,
    String? ghanaCardNumber,
    String? driverLicenseNumber,
    String? ghanaCardImageUrl,
    String? driverLicenseImageUrl,
    String? verificationStatus,
    double? rating,
    int? completedJobs,
    String? businessName,
    String? businessDescription,
    List<String>? serviceAreas,
    bool? isAvailable,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? region,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      ghanaCardNumber: ghanaCardNumber ?? this.ghanaCardNumber,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      ghanaCardImageUrl: ghanaCardImageUrl ?? this.ghanaCardImageUrl,
      driverLicenseImageUrl: driverLicenseImageUrl ?? this.driverLicenseImageUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      isAvailable: isAvailable ?? this.isAvailable,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
    );
  }
}