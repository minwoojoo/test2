import '../models/rental.dart';
import 'base_repository.dart';

class RentalRepository implements BaseRepository<Rental> {
  @override
  Future<Rental> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return Rental(
      id: id,
      userId: 'test-user-id',
      accessoryId: 'A1',
      stationId: 'S1',
      totalPrice: 5000,
      status: RentalStatus.active,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<List<Rental>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      Rental(
        id: 'rental-1',
        userId: 'test-user-id',
        accessoryId: 'A1',
        stationId: 'S1',
        totalPrice: 5000,
        status: RentalStatus.completed,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Rental(
        id: 'rental-2',
        userId: 'test-user-id',
        accessoryId: 'A2',
        stationId: 'S2',
        totalPrice: 7000,
        status: RentalStatus.completed,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
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
    final now = DateTime.now();
    return [
      Rental(
        id: 'rental-1',
        userId: userId,
        accessoryId: 'A1',
        stationId: 'S1',
        totalPrice: 5000,
        status: RentalStatus.completed,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Rental(
        id: 'rental-2',
        userId: userId,
        accessoryId: 'A2',
        stationId: 'S2',
        totalPrice: 7000,
        status: RentalStatus.completed,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<List<Rental>> getActiveRentals(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      Rental(
        id: 'rental-3',
        userId: userId,
        accessoryId: 'A3',
        stationId: 'S1',
        totalPrice: 3000,
        status: RentalStatus.active,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now,
      ),
    ];
  }

  Future<List<Rental>> getRentalHistory(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      Rental(
        id: 'rental-1',
        userId: userId,
        accessoryId: 'A1',
        stationId: 'S1',
        totalPrice: 5000,
        status: RentalStatus.completed,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Rental(
        id: 'rental-2',
        userId: userId,
        accessoryId: 'A2',
        stationId: 'S2',
        totalPrice: 7000,
        status: RentalStatus.completed,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<List<Rental>> getRecentRentals([String? userId]) async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      Rental(
        id: '2',
        userId: userId ?? 'test-user-id',
        accessoryId: 'A2',
        stationId: 'S1',
        totalPrice: 1500,
        status: RentalStatus.completed,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
