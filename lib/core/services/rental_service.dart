import '../models/rental.dart';

class RentalService {
  static final RentalService instance = RentalService._();
  RentalService._();

  Future<List<Rental>> getRentalHistory(String userId) async {
    // TODO: 실제 API 호출로 대체
    await Future.delayed(const Duration(seconds: 1));
    return [
      Rental(
        id: 'R1',
        userId: userId,
        accessoryId: 'A1',
        stationId: 'S1',
        totalPrice: 5000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      Rental(
        id: 'R2',
        userId: userId,
        accessoryId: 'A2',
        stationId: 'S2',
        totalPrice: 3000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
