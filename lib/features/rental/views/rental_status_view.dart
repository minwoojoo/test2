import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/rental_status_viewmodel.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/widgets/loading_animation.dart';
// import './rental_return_view.dart';
import './qr_scan_view.dart';

class RentalStatusView extends StatelessWidget {
  const RentalStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RentalStatusViewModel(),
      child: const _RentalStatusContent(),
    );
  }
}

class _RentalStatusContent extends StatelessWidget {
  const _RentalStatusContent();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('대여 현황'),
      ),
      child: SafeArea(
        child: Consumer<RentalStatusViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(
                child: HoneyLoadingAnimation(
                  isStationSelected: false,
                ),
              );
            }

            if (viewModel.error != null) {
              return Center(child: Text(viewModel.error!));
            }

            if (viewModel.activeRentals.isEmpty) {
              return const Center(
                child: Text('대여 중인 물품이 없습니다'),
              );
            }

            return DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
              child: ListView.builder(
                itemCount: viewModel.activeRentals.length,
                itemBuilder: (context, index) {
                  final rental = viewModel.activeRentals[index];
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: CupertinoColors.systemGrey5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rental.accessoryName,
                                style: AppTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                rental.stationName,
                                style: AppTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                rental.formattedRentalTime,
                                style: AppTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '남은 시간: ${rental.remainingTime.inHours}시간 ${rental.remainingTime.inMinutes % 60}분',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: CupertinoColors.activeBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: CupertinoColors.systemGrey5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('서비스 준비 중'),
                                        content: const Text(
                                          '해당 기능은 현재 준비 중입니다.\n잠시만 기다려주세요.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('확인'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text('연장하기'),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 44,
                                color: CupertinoColors.systemGrey5,
                              ),
                              Expanded(
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => QRScanView(
                                          rentalDuration: 0,
                                          isReturn: true,
                                          rental: rental,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('반납하기'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
