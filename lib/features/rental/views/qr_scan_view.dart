import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/rental.dart';
import '../viewmodels/qr_scan_viewmodel.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_colors.dart';
import '../../../app/routes.dart';
import '../../../core/widgets/loading_animation.dart';

class QRScanView extends StatelessWidget {
  final int rentalDuration;
  final bool isReturn;
  final Rental? rental;

  const QRScanView({
    super.key,
    required this.rentalDuration,
    this.isReturn = false,
    this.rental,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QRScanViewModel(
        rentalDuration: rentalDuration,
        isReturn: isReturn,
        initialRental: rental,
      )..onQRViewCreated(),
      child: const _QRScanContent(),
    );
  }
}

class _QRScanContent extends StatelessWidget {
  const _QRScanContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 스캔'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<QRScanViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.rental != null && !viewModel.isReturn) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(
                  Routes.payment,
                  arguments: viewModel.rental,
                );
              });
            }

            if (viewModel.isReturnComplete) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '반납이 완료되었습니다',
                      style: AppTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '의견을 남겨주세요',
                      style: AppTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          onPressed: () => viewModel.setRating(index + 1),
                          icon: Icon(
                            index < viewModel.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: index < viewModel.rating
                                ? Colors.amber
                                : Colors.grey,
                            size: 40,
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(Routes.home);
                      },
                      child: const Text('홈으로 돌아가기'),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.isScanning) ...[
                    const HoneyLoadingAnimation(
                      isStationSelected: true,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'QR 코드를 스캔하고 있습니다...',
                      style: AppTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ] else if (viewModel.isProcessing) ...[
                    const HoneyLoadingAnimation(
                      isStationSelected: true,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      viewModel.isReturn
                          ? '반납을 처리하고 있습니다...'
                          : 'QR 코드를 처리하고 있습니다...',
                      style: AppTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ] else if (viewModel.error != null) ...[
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: viewModel.resumeScanning,
                      child: const Text('다시 시도'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
