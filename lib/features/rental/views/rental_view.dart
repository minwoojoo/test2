import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../viewmodels/rental_viewmodel.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import '../../../app/routes.dart';
import './rental_detail_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';

class RentalView extends StatelessWidget {
  const RentalView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RentalViewModel(),
      child: const _RentalContent(),
    );
  }
}

class _RentalContent extends StatelessWidget {
  const _RentalContent();

  String _getCategoryName(AccessoryCategory category) {
    switch (category) {
      case AccessoryCategory.charger:
        return '충전기';
      case AccessoryCategory.powerBank:
        return '보조배터리';
      case AccessoryCategory.dock:
        return '거치대';
      case AccessoryCategory.etc:
        return '기타';
      default:
        return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('대여하기'),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.home);
                },
                child: const Icon(CupertinoIcons.back),
              ),
            ),
            child: SafeArea(
              child: Consumer<RentalViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (viewModel.error != null) {
                    return Center(child: Text(viewModel.error!));
                  }

                  return CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 16),
                      ),
                      CupertinoSliverRefreshControl(
                        onRefresh: viewModel.refresh,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (viewModel.selectedStation != null) ...[
                                const Text(
                                  '선택된 스테이션',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CupertinoColors.systemGrey5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.selectedStation!.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        viewModel.selectedStation!.address,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                              const Text(
                                '대여 가능한 물품',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 40,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: AccessoryCategory.values
                                      .map(
                                        (category) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: CupertinoButton(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            color: viewModel.selectedCategory ==
                                                    category
                                                ? CupertinoColors.activeBlue
                                                : CupertinoColors.systemGrey5,
                                            child: Text(
                                              _getCategoryName(category),
                                              style: TextStyle(
                                                color: viewModel
                                                            .selectedCategory ==
                                                        category
                                                    ? CupertinoColors.white
                                                    : CupertinoColors.black,
                                              ),
                                            ),
                                            onPressed: () => viewModel
                                                .selectCategory(category),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final accessory =
                                viewModel.filteredAccessories[index];
                            return GestureDetector(
                              onTap: () {
                                viewModel.selectAccessory(accessory);
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => RentalDetailView(
                                      accessory: accessory,
                                      station: viewModel.selectedStation,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  border: Border(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            accessory.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            accessory.description,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${accessory.pricePerHour}원/시간',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: viewModel.filteredAccessories.length,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const AppBottomNavigationBar(currentIndex: 1),
      ],
    );
  }
}
