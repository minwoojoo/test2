class Station {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final bool isActive;

  const Station({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.isActive = true,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
