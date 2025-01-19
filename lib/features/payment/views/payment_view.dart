import 'package:flutter/material.dart';
import '../../../data/models/rental.dart';
import '../../../app/routes.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/services/auth_service.dart';

class PaymentView extends StatefulWidget {
  final Map<String, dynamic> rentalInfo;

  const PaymentView({
    super.key,
    required this.rentalInfo,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  bool _isAgreed = false;
  String _selectedPaymentMethod = '신용카드';

  @override
  Widget build(BuildContext context) {
    final accessory = widget.rentalInfo['accessory'];
    final station = widget.rentalInfo['station'];
    final hours = widget.rentalInfo['hours'] as int;
    final totalPrice = accessory.pricePerHour * hours;

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            height: 1.5,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSection(
                        title: '상품 정보',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('스테이션: ${station.name}'),
                            const SizedBox(height: 8),
                            Text('상품: ${accessory.name}'),
                            const SizedBox(height: 8),
                            Text('대여 시간: $hours시간'),
                            const SizedBox(height: 8),
                            Text('가격: ${totalPrice}원'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: '결제 수단',
                        child: Column(
                          children: [
                            _buildPaymentMethodTile('신용카드'),
                            _buildPaymentMethodTile('카카오페이'),
                            _buildPaymentMethodTile('네이버페이'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        title: '약관 동의',
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  _isAgreed = !_isAgreed;
                                });
                              },
                              icon: Icon(
                                _isAgreed
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: _isAgreed ? Colors.blue : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text('결제 진행 및 대여 약관에 동의합니다'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '총 결제 금액: ${totalPrice}원',
                      style: AppTheme.titleMedium,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isAgreed
                          ? () {
                              final rental = Rental(
                                id: 'R${DateTime.now().millisecondsSinceEpoch}',
                                userId:
                                    AuthService.instance.currentUser?.id ?? '',
                                accessoryId: accessory.id,
                                stationId: station.id,
                                totalPrice: totalPrice,
                                status: RentalStatus.active,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );
                              Navigator.of(context).pushReplacementNamed(
                                Routes.paymentComplete,
                                arguments: rental,
                              );
                            }
                          : null,
                      child: const Text('결제하기'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(String method) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
      onPressed: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              _selectedPaymentMethod == method
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  _selectedPaymentMethod == method ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(method),
          ],
        ),
      ),
    );
  }
}
