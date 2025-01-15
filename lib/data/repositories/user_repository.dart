import '../models/user.dart';
import '../models/rental.dart';
import 'base_repository.dart';

class UserRepository implements BaseRepository<User> {
  @override
  Future<User> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: id,
      email: 'test@example.com',
      name: '테스트 사용자',
      phoneNumber: '010-1234-5678',
      profileImageUrl: 'https://example.com/images/profile.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rentals: [
        Rental(
          id: 'rental-1',
          userId: id,
          accessoryId: 'accessory-1',
          stationId: 'station-1',
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          totalPrice: 3000,
          status: RentalStatus.active,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now(),
        ),
        Rental(
          id: 'rental-2',
          userId: id,
          accessoryId: 'accessory-2',
          stationId: 'station-2',
          startTime: DateTime.now().subtract(const Duration(days: 1)),
          endTime: DateTime.now().subtract(const Duration(hours: 20)),
          totalPrice: 5000,
          status: RentalStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 20)),
        ),
      ],
    );
  }

  @override
  Future<List<User>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      User(
        id: 'user-1',
        email: 'user1@example.com',
        name: '사용자 1',
        phoneNumber: '010-1234-5678',
        profileImageUrl: 'https://example.com/images/profile1.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rentals: [
          Rental(
            id: 'rental-1',
            userId: 'user-1',
            accessoryId: 'accessory-1',
            stationId: 'station-1',
            startTime: DateTime.now().subtract(const Duration(hours: 2)),
            endTime: DateTime.now().add(const Duration(hours: 1)),
            totalPrice: 3000,
            status: RentalStatus.active,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            updatedAt: DateTime.now(),
          ),
        ],
      ),
      User(
        id: 'user-2',
        email: 'user2@example.com',
        name: '사용자 2',
        phoneNumber: '010-2345-6789',
        profileImageUrl: 'https://example.com/images/profile2.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rentals: [],
      ),
    ];
  }

  @override
  Future<User> create(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  @override
  Future<User> update(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<User> getByEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: 'user-1',
      email: email,
      name: '테스트 사용자',
      phoneNumber: '010-1234-5678',
      profileImageUrl: 'https://example.com/images/profile.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rentals: [
        Rental(
          id: 'rental-1',
          userId: 'user-1',
          accessoryId: 'accessory-1',
          stationId: 'station-1',
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          totalPrice: 3000,
          status: RentalStatus.active,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now(),
        ),
      ],
    );
  }
}
