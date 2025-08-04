import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String clientId;
  final String? moverId;
  final String title;
  final String description;
  final String status; // 'pending', 'accepted', 'in_progress', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? scheduledDate;
  final double? estimatedPrice;
  final double? finalPrice;
  
  // Location details
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  
  // Request details
  final String moveType; // 'residential', 'office', 'commercial'
  final String propertySize; // 'studio', '1-bedroom', '2-bedroom', etc.
  final List<String> items;
  final List<String> specialInstructions;
  final bool needsPackingService;
  final bool needsUnpackingService;
  final bool hasFragileItems;
  final bool hasHeavyItems;
  final int? numberOfBoxes;
  final int? numberOfWorkers;
  final String? vehicleType;
  
  // Images
  final List<String> imageUrls;
  
  // Communication
  final String? chatId;
  
  // Tracking
  final List<RequestUpdate> updates;

  RequestModel({
    required this.id,
    required this.clientId,
    this.moverId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledDate,
    this.estimatedPrice,
    this.finalPrice,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.moveType,
    required this.propertySize,
    required this.items,
    required this.specialInstructions,
    required this.needsPackingService,
    required this.needsUnpackingService,
    required this.hasFragileItems,
    required this.hasHeavyItems,
    this.numberOfBoxes,
    this.numberOfWorkers,
    this.vehicleType,
    required this.imageUrls,
    this.chatId,
    required this.updates,
  });

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get hasAssignedMover => moverId != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'moverId': moverId,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'scheduledDate': scheduledDate,
      'estimatedPrice': estimatedPrice,
      'finalPrice': finalPrice,
      'pickupAddress': pickupAddress,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'deliveryAddress': deliveryAddress,
      'deliveryLatitude': deliveryLatitude,
      'deliveryLongitude': deliveryLongitude,
      'moveType': moveType,
      'propertySize': propertySize,
      'items': items,
      'specialInstructions': specialInstructions,
      'needsPackingService': needsPackingService,
      'needsUnpackingService': needsUnpackingService,
      'hasFragileItems': hasFragileItems,
      'hasHeavyItems': hasHeavyItems,
      'numberOfBoxes': numberOfBoxes,
      'numberOfWorkers': numberOfWorkers,
      'vehicleType': vehicleType,
      'imageUrls': imageUrls,
      'chatId': chatId,
      'updates': updates.map((update) => update.toMap()).toList(),
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] ?? '',
      clientId: map['clientId'] ?? '',
      moverId: map['moverId'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      scheduledDate: (map['scheduledDate'] as Timestamp?)?.toDate(),
      estimatedPrice: map['estimatedPrice']?.toDouble(),
      finalPrice: map['finalPrice']?.toDouble(),
      pickupAddress: map['pickupAddress'] ?? '',
      pickupLatitude: map['pickupLatitude']?.toDouble() ?? 0.0,
      pickupLongitude: map['pickupLongitude']?.toDouble() ?? 0.0,
      deliveryAddress: map['deliveryAddress'] ?? '',
      deliveryLatitude: map['deliveryLatitude']?.toDouble() ?? 0.0,
      deliveryLongitude: map['deliveryLongitude']?.toDouble() ?? 0.0,
      moveType: map['moveType'] ?? 'residential',
      propertySize: map['propertySize'] ?? '',
      items: List<String>.from(map['items'] ?? []),
      specialInstructions: List<String>.from(map['specialInstructions'] ?? []),
      needsPackingService: map['needsPackingService'] ?? false,
      needsUnpackingService: map['needsUnpackingService'] ?? false,
      hasFragileItems: map['hasFragileItems'] ?? false,
      hasHeavyItems: map['hasHeavyItems'] ?? false,
      numberOfBoxes: map['numberOfBoxes'],
      numberOfWorkers: map['numberOfWorkers'],
      vehicleType: map['vehicleType'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      chatId: map['chatId'],
      updates: (map['updates'] as List<dynamic>?)
              ?.map((update) => RequestUpdate.fromMap(update))
              .toList() ??
          [],
    );
  }

  RequestModel copyWith({
    String? id,
    String? clientId,
    String? moverId,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? scheduledDate,
    double? estimatedPrice,
    double? finalPrice,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? moveType,
    String? propertySize,
    List<String>? items,
    List<String>? specialInstructions,
    bool? needsPackingService,
    bool? needsUnpackingService,
    bool? hasFragileItems,
    bool? hasHeavyItems,
    int? numberOfBoxes,
    int? numberOfWorkers,
    String? vehicleType,
    List<String>? imageUrls,
    String? chatId,
    List<RequestUpdate>? updates,
  }) {
    return RequestModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      moverId: moverId ?? this.moverId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      moveType: moveType ?? this.moveType,
      propertySize: propertySize ?? this.propertySize,
      items: items ?? this.items,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      needsPackingService: needsPackingService ?? this.needsPackingService,
      needsUnpackingService: needsUnpackingService ?? this.needsUnpackingService,
      hasFragileItems: hasFragileItems ?? this.hasFragileItems,
      hasHeavyItems: hasHeavyItems ?? this.hasHeavyItems,
      numberOfBoxes: numberOfBoxes ?? this.numberOfBoxes,
      numberOfWorkers: numberOfWorkers ?? this.numberOfWorkers,
      vehicleType: vehicleType ?? this.vehicleType,
      imageUrls: imageUrls ?? this.imageUrls,
      chatId: chatId ?? this.chatId,
      updates: updates ?? this.updates,
    );
  }
}

class RequestUpdate {
  final String status;
  final String message;
  final DateTime timestamp;
  final String? location;
  final double? latitude;
  final double? longitude;

  RequestUpdate({
    required this.status,
    required this.message,
    required this.timestamp,
    this.location,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'timestamp': timestamp,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory RequestUpdate.fromMap(Map<String, dynamic> map) {
    return RequestUpdate(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: map['location'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }
}