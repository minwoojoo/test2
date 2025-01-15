import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../data/models/rental.dart';
import '../viewmodels/payment_viewmodel.dart';
import '../../../app/routes.dart';

class PaymentView extends StatelessWidget {
  final Rental rental;

  const PaymentView({
    super.key,
    required this.rental,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(rental: rental),
      child: const _PaymentContent(),
    );
  }
}

class _PaymentContent extends StatelessWidget {
  const _PaymentContent();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('결제하기'),
      ),
      child: SafeArea(
        child: Consumer<PaymentViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isComplete) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(
                  Routes.paymentComplete,
                  arguments: viewModel.rental,
                );
              });
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderInfo(viewModel),
                        const SizedBox(height: 24),
                        _buildPaymentMethods(viewModel),
                        const SizedBox(height: 24),
                        _buildAgreement(),
                      ],
                    ),
                  ),
                ),
                _buildBottomPayment(context, viewModel),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderInfo(PaymentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('상품 정보', style: AppTheme.titleMedium),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Column(
            children: [
              _buildInfoRow('대여 ID', viewModel.rental.id),
              const SizedBox(height: 8),
              _buildInfoRow('대여 시간',
                  '${viewModel.rental.startTime} ~ ${viewModel.rental.endTime}'),
              const SizedBox(height: 8),
              _buildInfoRow('결제 금액', '${viewModel.rental.totalPrice}원'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(PaymentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제 수단', style: AppTheme.titleMedium),
        const SizedBox(height: 16),
        ...PaymentMethod.values.map((method) {
          final isSelected = method == viewModel.selectedMethod;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => viewModel.selectPaymentMethod(method),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.lightGrey,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? CupertinoIcons.checkmark_circle_fill
                          : CupertinoIcons.circle,
                      color: isSelected ? AppColors.primary : AppColors.grey,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      viewModel.getPaymentMethodName(method),
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAgreement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제 동의', style: AppTheme.titleMedium),
        const SizedBox(height: 16),
        Text(
          '위 내용을 확인하였으며, 결제에 동의합니다.',
          style: AppTheme.bodyMedium.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildBottomPayment(BuildContext context, PaymentViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.lightGrey),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 결제 금액', style: AppTheme.titleMedium),
              Text(
                '${viewModel.rental.totalPrice}원',
                style: AppTheme.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: AppColors.primary,
              onPressed: viewModel.isProcessing
                  ? null
                  : () => viewModel.processPayment(context),
              child: viewModel.isProcessing
                  ? const CupertinoActivityIndicator()
                  : const Text(
                      '결제하기',
                      style: TextStyle(color: AppColors.black),
                    ),
            ),
          ),
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
