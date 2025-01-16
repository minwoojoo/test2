import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../viewmodels/station_selection_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/widgets/loading_animation.dart';
import '../../../data/models/station.dart';

class StationSelectionView extends StatelessWidget {
  final Station? currentStation;

  const StationSelectionView({
    super.key,
    this.currentStation,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          StationSelectionViewModel(currentStation: currentStation),
      child: const _StationSelectionContent(),
    );
  }
}

class _StationSelectionContent extends StatelessWidget {
  const _StationSelectionContent();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('스테이션 선택'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: Consumer<StationSelectionViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: HoneyLoadingAnimation(
                  isStationSelected: false,
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CupertinoSearchTextField(
                    placeholder: '스테이션 검색',
                    onChanged: viewModel.searchStations,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.filteredStations.length,
                    itemBuilder: (context, index) {
                      final station = viewModel.filteredStations[index];
                      final isSelected =
                          viewModel.currentStation?.id == station.id;

                      return GestureDetector(
                        onTap: () {
                          viewModel.selectStation(station);
                          Navigator.of(context).pop(station);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : null,
                            border: const Border(
                              bottom: BorderSide(
                                color: CupertinoColors.systemGrey5,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station.name,
                                      style: AppTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      station.address,
                                      style: AppTheme.bodySmall.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  CupertinoIcons.checkmark_circle_fill,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
