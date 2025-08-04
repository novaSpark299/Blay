import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus { pending, accepted, inProgress, completed, cancelled }

enum RequestType { residential, office, commercial, storage }

class RequestModel {
  final String id;
  final String clientId;
  final String? moverId;
  final String title;
  final String description;
  final RequestType requestType;
  final RequestStatus status;
  final DateTime requestDate;
  final DateTime? preferredDate;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final double? estimatedPrice;
  final double? finalPrice;
  final List<String> items;
  final List<String>? imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? specialInstructions;
  final bool isUrgent;
  final Map<String, dynamic>? clientRating;
  final Map<String, dynamic>? moverRating;

  RequestModel({
    required this.id,
    required this.clientId,
    this.moverId,
    required this.title,
    required this.description,
    required this.requestType,
    required this.status,
    required this.requestDate,
    this.preferredDate,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    this.estimatedPrice,
    this.finalPrice,
    required this.items,
    this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    this.specialInstructions,
    required this.isUrgent,
    this.clientRating,
    this.moverRating,
  });

  factory RequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return RequestModel(
      id: doc.id,
      clientId: data['clientId'] ?? '',
      moverId: data['moverId'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      requestType: RequestType.values.firstWhere(
        (type) => type.toString().split('.').last == data['requestType'],
        orElse: () => RequestType.residential,
      ),
      status: RequestStatus.values.firstWhere(
        (status) => status.toString().split('.').last == data['status'],
        orElse: () => RequestStatus.pending,
      ),
      requestDate: (data['requestDate'] as Timestamp).toDate(),
      preferredDate: (data['preferredDate'] as Timestamp?)?.toDate(),
      pickupAddress: data['pickupAddress'] ?? '',
      pickupLatitude: data['pickupLatitude']?.toDouble() ?? 0.0,
      pickupLongitude: data['pickupLongitude']?.toDouble() ?? 0.0,
      deliveryAddress: data['deliveryAddress'] ?? '',
      deliveryLatitude: data['deliveryLatitude']?.toDouble() ?? 0.0,
      deliveryLongitude: data['deliveryLongitude']?.toDouble() ?? 0.0,
      estimatedPrice: data['estimatedPrice']?.toDouble(),
      finalPrice: data['finalPrice']?.toDouble(),
      items: List<String>.from(data['items'] ?? []),
      imageUrls: data['imageUrls'] != null ? List<String>.from(data['imageUrls']) : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      specialInstructions: data['specialInstructions'],
      isUrgent: data['isUrgent'] ?? false,
      clientRating: data['clientRating'] != null 
          ? Map<String, dynamic>.from(data['clientRating']) 
          : null,
      moverRating: data['moverRating'] != null 
          ? Map<String, dynamic>.from(data['moverRating']) 
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'clientId': clientId,
      'moverId': moverId,
      'title': title,
      'description': description,
      'requestType': requestType.toString().split('.').last,
      'status': status.toString().split('.').last,
      'requestDate': Timestamp.fromDate(requestDate),
      'preferredDate': preferredDate != null ? Timestamp.fromDate(preferredDate!) : null,
      'pickupAddress': pickupAddress,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'deliveryAddress': deliveryAddress,
      'deliveryLatitude': deliveryLatitude,
      'deliveryLongitude': deliveryLongitude,
      'estimatedPrice': estimatedPrice,
      'finalPrice': finalPrice,
      'items': items,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'specialInstructions': specialInstructions,
      'isUrgent': isUrgent,
      'clientRating': clientRating,
      'moverRating': moverRating,
    };
  }

  RequestModel copyWith({
    String? moverId,
    String? title,
    String? description,
    RequestType? requestType,
    RequestStatus? status,
    DateTime? requestDate,
    DateTime? preferredDate,
    String? pickupAddress,
    double? pickupLatitude,
    double? pickupLongitude,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    double? estimatedPrice,
    double? finalPrice,
    List<String>? items,
    List<String>? imageUrls,
    DateTime? updatedAt,
    String? specialInstructions,
    bool? isUrgent,
    Map<String, dynamic>? clientRating,
    Map<String, dynamic>? moverRating,
  }) {
    return RequestModel(
      id: id,
      clientId: clientId,
      moverId: moverId ?? this.moverId,
      title: title ?? this.title,
      description: description ?? this.description,
      requestType: requestType ?? this.requestType,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      preferredDate: preferredDate ?? this.preferredDate,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      items: items ?? this.items,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      specialInstructions: specialInstructions ?? this.specialInstructions,
      isUrgent: isUrgent ?? this.isUrgent,
      clientRating: clientRating ?? this.clientRating,
      moverRating: moverRating ?? this.moverRating,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.inProgress:
        return 'In Progress';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get requestTypeDisplayName {
    switch (requestType) {
      case RequestType.residential:
        return 'Residential Move';
      case RequestType.office:
        return 'Office Move';
      case RequestType.commercial:
        return 'Commercial Move';
      case RequestType.storage:
        return 'Storage Move';
    }
  }
}