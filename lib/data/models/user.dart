import 'rental.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final String profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Rental> rentals;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.rentals = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      rentals: json['rentals'] != null
          ? (json['rentals'] as List)
              .map((rental) => Rental.fromJson(rental))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rentals': rentals.map((rental) => rental.toJson()).toList(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Rental>? rentals,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rentals: rentals ?? this.rentals,
    );
  }

  List<Rental> get activeRentals =>
      rentals.where((rental) => rental.status == RentalStatus.active).toList();
  List<Rental> get completedRentals => rentals
      .where((rental) => rental.status == RentalStatus.completed)
      .toList();
  bool get hasActiveRental => activeRentals.isNotEmpty;
}
