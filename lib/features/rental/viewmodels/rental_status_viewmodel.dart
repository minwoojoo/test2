import 'package:flutter/foundation.dart';
import '../../../data/models/rental.dart';
import '../../../core/services/auth_service.dart';

class RentalStatusViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Rental> _activeRentals = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Rental> get activeRentals => _activeRentals;

  RentalStatusViewModel() {
    _loadActiveRentals();
  }

  Future<void> _loadActiveRentals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await AuthService.instance.currentUser;
      if (user == null) {
        _error = '로그인이 필요합니다';
        return;
      }

      // TODO: 실제 API 연동
      await Future.delayed(const Duration(seconds: 1));
      _activeRentals = [
        Rental(
          id: 'R123',
          userId: user.id,
          accessoryId: '충전기 A',
          stationId: '강남역점',
          startTime: DateTime.now().subtract(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          totalPrice: 3000,
          status: RentalStatus.active,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Rental(
          id: 'R124',
          userId: user.id,
          accessoryId: '보조배터리 B',
          stationId: '홍대입구역점',
          startTime: DateTime.now().subtract(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          totalPrice: 4000,
          status: RentalStatus.active,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => _loadActiveRentals();
}
