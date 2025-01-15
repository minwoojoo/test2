import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../viewmodels/qr_scan_viewmodel.dart';
import '../../../app/routes.dart';

class QRScanView extends StatelessWidget {
  final int rentalDuration;

  const QRScanView({
    super.key,
    required this.rentalDuration,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QRScanViewModel(
        rentalDuration: rentalDuration,
      )..onQRViewCreated(),
      child: const _QRScanContent(),
    );
  }
}

class _QRScanContent extends StatelessWidget {
  const _QRScanContent();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('QR 스캔'),
      ),
      child: SafeArea(
        child: Consumer<QRScanViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.rental != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(
                  Routes.payment,
                  arguments: viewModel.rental,
                );
              });
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.isScanning) ...[
                    const CupertinoActivityIndicator(radius: 20),
                    const SizedBox(height: 24),
                    Text(
                      'QR 코드를 스캔하고 있습니다...',
                      style: AppTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ] else if (viewModel.isProcessing) ...[
                    const CupertinoActivityIndicator(radius: 20),
                    const SizedBox(height: 24),
                    Text(
                      'QR 코드를 처리하고 있습니다...',
                      style: AppTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ] else if (viewModel.error != null) ...[
                    Icon(
                      CupertinoIcons.exclamationmark_circle_fill,
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
                    CupertinoButton(
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
