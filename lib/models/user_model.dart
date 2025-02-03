import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final int availableTime;
  final DateTime createdAt;
  final String email;
  final String id;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final List<dynamic> rentalHistory;

  UserModel({
    required this.availableTime,
    required this.createdAt,
    required this.email,
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.rentalHistory,
  });

  factory UserModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return UserModel(
      availableTime: data['available_time'] ?? -1,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      email: data['email'] ?? '',
      id: documentId,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      rentalHistory: data['rentalHistory'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'available_time': availableTime,
      'createdAt': Timestamp.fromDate(createdAt),
      'email': email,
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'rentalHistory': rentalHistory,
    };
  }
}
