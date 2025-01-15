enum AccessoryCategory {
  charger,
  cable,
  dock,
  powerBank,
  etc,
}

class Accessory {
  final String id;
  final String name;
  final String description;
  final int pricePerHour;
  final AccessoryCategory category;
  final bool isAvailable;
  final String imageUrl;

  Accessory({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerHour,
    required this.category,
    required this.isAvailable,
    required this.imageUrl,
  });

  factory Accessory.fromJson(Map<String, dynamic> json) {
    return Accessory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerHour: json['pricePerHour'] as int,
      category: AccessoryCategory.values[json['category'] as int],
      isAvailable: json['isAvailable'] as bool,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pricePerHour': pricePerHour,
      'category': category.index,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
    };
  }
}
