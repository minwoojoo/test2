enum RentalStatus {
  active,
  completed,
  cancelled,
}

class Rental {
  final String id;
  final String userId;
  final String accessoryId;
  final String stationId;
  final int totalPrice;
  final RentalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Rental({
    required this.id,
    required this.userId,
    required this.accessoryId,
    required this.stationId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedRentalTime {
    final startTime = createdAt.toString().substring(0, 19);
    final endTime = updatedAt.toString().substring(0, 19);
    return '$startTime ~ $endTime';
  }

  // 대여 시간 계산 (24시간 기준)
  Duration get remainingTime {
    final rentalDuration = const Duration(hours: 24);
    final elapsedTime = DateTime.now().difference(createdAt);
    final remaining = rentalDuration - elapsedTime;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get accessoryName {
    switch (accessoryId) {
      case 'A1':
        return '아이폰 충전기';
      case 'A2':
        return '보조배터리';
      case 'A3':
        return '안드로이드 충전기';
      case 'A4':
        return 'C타입 충전기';
      default:
        return '알 수 없는 악세서리';
    }
  }

  String get stationName {
    switch (stationId) {
      case 'S1':
        return '강남역점';
      case 'S2':
        return '홍대입구역점';
      case 'S3':
        return '명동점';
      case 'S4':
        return '여의도역점';
      default:
        return '알 수 없는 스테이션';
    }
  }
}
