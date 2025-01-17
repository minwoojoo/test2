enum RentalStatus {
  pending,
  active,
  completed,
  cancelled,
}

class Rental {
  final String id;
  final String userId;
  final String accessoryId;
  final String stationId;
  final DateTime startTime;
  final DateTime endTime;
  final int totalPrice;
  final RentalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Rental({
    required this.id,
    required this.userId,
    required this.accessoryId,
    required this.stationId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id'] as String,
      userId: json['userId'] as String,
      accessoryId: json['accessoryId'] as String,
      stationId: json['stationId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      totalPrice: json['totalPrice'] as int,
      status: RentalStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'accessoryId': accessoryId,
      'stationId': stationId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Rental copyWith({
    String? id,
    String? userId,
    String? accessoryId,
    String? stationId,
    DateTime? startTime,
    DateTime? endTime,
    int? totalPrice,
    RentalStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Rental(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accessoryId: accessoryId ?? this.accessoryId,
      stationId: stationId ?? this.stationId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration get duration => endTime.difference(startTime);
  bool get isActive => status == RentalStatus.active;
  bool get isCompleted => status == RentalStatus.completed;
  bool get isPending => status == RentalStatus.pending;
  bool get isCancelled => status == RentalStatus.cancelled;
  bool get isExpired => endTime.isBefore(DateTime.now());
  bool get canBeExtended => isActive && !isExpired;
  Duration get remainingTime {
    final now = DateTime.now();
    if (now.isAfter(endTime)) return Duration.zero;
    return endTime.difference(now);
  }

  String get formattedStartTime {
    return '${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')} ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:${startTime.second.toString().padLeft(2, '0')}';
  }

  String get formattedEndTime {
    return '${endTime.year}-${endTime.month.toString().padLeft(2, '0')}-${endTime.day.toString().padLeft(2, '0')} ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}:${endTime.second.toString().padLeft(2, '0')}';
  }

  String get formattedTimeRange {
    return '$formattedStartTime ~ $formattedEndTime';
  }
}
