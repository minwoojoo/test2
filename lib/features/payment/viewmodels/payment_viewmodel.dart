import 'package:flutter/foundation.dart';
import '../../../data/models/rental.dart';
import '../../../data/repositories/rental_repository.dart';
import 'package:flutter/material.dart';

enum PaymentMethod {
  card,
  toss,
  naver,
  kakao,
}

class PaymentViewModel with ChangeNotifier {
  final RentalRepository _rentalRepository;
  final Rental _rental;

  PaymentMethod _selectedMethod = PaymentMethod.card;
  bool _isProcessing = false;
  String? _error;
  bool _isComplete = false;

  PaymentViewModel({
    required Rental rental,
    RentalRepository? rentalRepository,
  })  : _rental = rental,
        _rentalRepository = rentalRepository ?? RentalRepository();

  PaymentMethod get selectedMethod => _selectedMethod;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  bool get isComplete => _isComplete;
  Rental get rental => _rental;

  void selectPaymentMethod(PaymentMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  Future<void> processPayment(BuildContext context) async {
    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      // 결제 프로세스 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));

      // 결제 성공 처리
      _isComplete = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  String getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return '카드 결제';
      case PaymentMethod.toss:
        return '토스 결제';
      case PaymentMethod.naver:
        return '네이버페이';
      case PaymentMethod.kakao:
        return '카카오페이';
    }
  }
}
