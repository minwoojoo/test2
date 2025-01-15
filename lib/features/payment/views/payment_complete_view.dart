import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../data/models/rental.dart';
import '../../../app/routes.dart';

class PaymentCompleteView extends StatelessWidget {
  final Rental rental;

  const PaymentCompleteView({
    super.key,
    required this.rental,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('결제 완료'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: AppColors.primary,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                '결제가 완료되었습니다',
                style: AppTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '대여가 시작되었습니다.\n즐거운 시간 보내세요!',
                style: AppTheme.bodyMedium.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildOrderSummary(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: AppColors.primary,
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routes.home, (route) => false),
                  child: const Text(
                    '홈으로 돌아가기',
                    style: TextStyle(color: AppColors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          _buildInfoRow('대여 ID', rental.id),
          const SizedBox(height: 8),
          _buildInfoRow('대여 시간', '${rental.startTime} ~ ${rental.endTime}'),
          const SizedBox(height: 8),
          _buildInfoRow('결제 금액', '${rental.totalPrice}원'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(color: AppColors.grey),
        ),
        Text(value, style: AppTheme.bodyMedium),
      ],
    );
  }
}
