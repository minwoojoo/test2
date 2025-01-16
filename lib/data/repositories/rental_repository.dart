import '../models/rental.dart';
import 'base_repository.dart';

class RentalRepository implements BaseRepository<Rental> {
  @override
  Future<Rental> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return Rental(
      id: id,
      userId: 'test-user-id',
      accessoryId: 'test-accessory-id',
      stationId: 'test-station-id',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      totalPrice: 5000,
      status: RentalStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<Rental>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Rental(
        id: 'rental-1',
        userId: 'test-user-id',
        accessoryId: 'accessory-1',
        stationId: 'station-1',
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now(),
        totalPrice: 5000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      Rental(
        id: 'rental-2',
        userId: 'test-user-id',
        accessoryId: 'accessory-2',
        stationId: 'station-2',
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 1)),
        totalPrice: 7000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<Rental> create(Rental rental) async {
    await Future.delayed(const Duration(seconds: 1));
    return rental;
  }

  @override
  Future<Rental> update(Rental rental) async {
    await Future.delayed(const Duration(seconds: 1));
    return rental;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<List<Rental>> getByUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Rental(
        id: 'rental-1',
        userId: userId,
        accessoryId: 'accessory-1',
        stationId: 'station-1',
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now(),
        totalPrice: 5000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      Rental(
        id: 'rental-2',
        userId: userId,
        accessoryId: 'accessory-2',
        stationId: 'station-2',
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 1)),
        totalPrice: 7000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<List<Rental>> getActiveRentals(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Rental(
        id: 'rental-3',
        userId: userId,
        accessoryId: 'accessory-3',
        stationId: 'station-1',
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        totalPrice: 3000,
        status: RentalStatus.active,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Future<List<Rental>> getRentalHistory(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Rental(
        id: 'rental-1',
        userId: userId,
        accessoryId: 'accessory-1',
        stationId: 'station-1',
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now(),
        totalPrice: 5000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      Rental(
        id: 'rental-2',
        userId: userId,
        accessoryId: 'accessory-2',
        stationId: 'station-2',
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 1)),
        totalPrice: 7000,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<List<Rental>> getRecentRentals([String? userId]) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Rental(
        id: '2',
        userId: userId ?? 'test-user-id',
        accessoryId: '2',
        stationId: '1',
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 3)),
        totalPrice: 1500,
        status: RentalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
