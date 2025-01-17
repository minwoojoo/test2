import 'package:flutter/foundation.dart';
import '../../../data/models/rental.dart';
import '../../../data/repositories/rental_repository.dart';
import '../../../data/repositories/accessory_repository.dart';

class QRScanViewModel with ChangeNotifier {
  final RentalRepository _rentalRepository;
  final AccessoryRepository _accessoryRepository;
  final int _rentalDuration;
  final bool isReturn;
  final Rental? initialRental;

  bool _isScanning = true;
  bool _isProcessing = false;
  String? _error;
  Rental? _rental;
  bool _isReturnComplete = false;
  int _rating = 0;

  QRScanViewModel({
    RentalRepository? rentalRepository,
    AccessoryRepository? accessoryRepository,
    required int rentalDuration,
    this.isReturn = false,
    this.initialRental,
  })  : _rentalRepository = rentalRepository ?? RentalRepository(),
        _accessoryRepository = accessoryRepository ?? AccessoryRepository(),
        _rentalDuration = rentalDuration;

  bool get isScanning => _isScanning;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  Rental? get rental => _rental;
  bool get isReturnComplete => _isReturnComplete;
  int get rating => _rating;

  void setRating(int value) {
    _rating = value;
    notifyListeners();
  }

  // QR 코드 스캔 시뮬레이션
  Future<void> onQRViewCreated() async {
    await Future.delayed(const Duration(seconds: 3)); // QR 스캔 시뮬레이션
    if (isReturn) {
      await processReturnQRCode('test-station-id');
    } else {
      await processRentalQRCode('test-accessory-id');
    }
  }

  // 대여 QR 코드 처리
  Future<void> processRentalQRCode(String accessoryId) async {
    _isScanning = false;
    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // 처리 시뮬레이션

      // 테스트 대여 생성
      _rental = Rental(
        id: 'test-rental-id',
        userId: 'test-user-id',
        accessoryId: accessoryId,
        stationId: 'test-station-id',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: _rentalDuration)),
        totalPrice: _rentalDuration * 1000, // 시간당 1000원
        status: RentalStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // 반납 QR 코드 처리
  Future<void> processReturnQRCode(String stationId) async {
    if (initialRental == null) {
      _error = '반납할 대여 정보가 없습니다';
      notifyListeners();
      return;
    }

    _isScanning = false;
    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // 처리 시뮬레이션

      // 테스트 반납 처리
      _rental = initialRental!.copyWith(
        status: RentalStatus.completed,
        updatedAt: DateTime.now(),
      );
      _isReturnComplete = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void resumeScanning() {
    _isScanning = true;
    _error = null;
    notifyListeners();
  }
}
