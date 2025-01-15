import '../../data/models/user.dart';
import '../services/storage_service.dart';

class AuthService {
  static late AuthService instance;
  static Future<void> initialize() async {
    instance = AuthService();
    await instance._init();
  }

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> _init() async {
    await StorageService.instance.init();
    final userData = StorageService.instance.getObject('user');
    if (userData != null) {
      _currentUser = User.fromJson(userData);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == 'test1234') {
      _currentUser = User(
        id: 'test-user-id',
        email: email,
        name: '테스트 사용자',
        phoneNumber: '010-1234-5678',
        profileImageUrl: 'https://example.com/images/profile.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rentals: [],
      );
      await StorageService.instance.setObject('user', _currentUser!.toJson());
    } else {
      throw Exception('이메일 또는 비밀번호가 올바르지 않습니다.');
    }
  }

  Future<void> signInWithTestUser() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: 'test-user-id',
      email: 'test@test.com',
      name: '테스트 사용자',
      phoneNumber: '010-1234-5678',
      profileImageUrl: 'https://example.com/images/profile.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rentals: [],
    );
    await StorageService.instance.setObject('user', _currentUser!.toJson());
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    await StorageService.instance.remove('user');
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: 'https://example.com/images/profile.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rentals: [],
    );
    await StorageService.instance.setObject('user', _currentUser!.toJson());
  }
}
