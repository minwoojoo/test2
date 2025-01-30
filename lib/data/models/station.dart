class Station {
  final String id;
  final String name;
  final String address;
  final bool isActive;
  final double? latitude;
  final double? longitude;

  const Station({
    required this.id,
    required this.name,
    required this.address,
    this.isActive = true,
    this.latitude,
    this.longitude,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      isActive: json['isActive'] as bool? ?? true,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'isActive': isActive,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
