import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import '../../../core/widgets/loading_animation.dart';
import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Column(
        children: [
          Expanded(
            child: CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(
                middle: Text('Bannabee'),
                automaticallyImplyLeading: false,
              ),
              child: SafeArea(
                child: Consumer<HomeViewModel>(
                  builder: (context, viewModel, child) {
                    if (!viewModel.hasLocationPermission) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '위치 권한이 필요합니다',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '주변 스테이션을 찾기 위해\n위치 권한이 필요합니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            CupertinoButton.filled(
                              child: const Text('위치 권한 허용'),
                              onPressed: () async {
                                final hasPermission =
                                    await viewModel.requestLocationPermission();
                                if (!hasPermission) {
                                  if (context.mounted) {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoAlertDialog(
                                        title: const Text('위치 권한 필요'),
                                        content: const Text(
                                          '주변 스테이션을 찾기 위해 위치 권한이 필요합니다.\n설정에서 위치 권한을 허용해주세요.',
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text('취소'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // TODO: 시스템 설정으로 이동
                                            },
                                            child: const Text('설정으로 이동'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }

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

                    return CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: viewModel.refresh,
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildSearchBar(),
                                const SizedBox(height: 16),
                                _buildNoticeSection(context, viewModel),
                              ],
                            ),
                          ),
                        ),
                        _buildActiveRentals(viewModel),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 8,
                            color: CupertinoColors.systemGrey6,
                          ),
                        ),
                        _buildRecentRentals(viewModel),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 8,
                            color: CupertinoColors.systemGrey6,
                          ),
                        ),
                        _buildNearbyStations(context, viewModel),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const AppBottomNavigationBar(currentIndex: 0),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // TODO: 검색 화면으로 이동
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(
              CupertinoIcons.search,
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              '검색',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeSection(BuildContext context, HomeViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        // TODO: 공지사항 목록으로 이동
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CupertinoColors.systemGrey5),
        ),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.info_circle,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.latestNotice?.title ?? '새로운 공지사항이 없습니다.',
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRentals(HomeViewModel viewModel) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '현재 대여 중',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (viewModel.activeRentals.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('대여 중인 물품이 없습니다.'),
          )
        else
          ...viewModel.activeRentals.map((rental) => Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey5,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.id,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '남은 시간: ${rental.remainingTime.inHours}시간 ${rental.remainingTime.inMinutes % 60}분',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              )),
      ]),
    );
  }

  Widget _buildRecentRentals(HomeViewModel viewModel) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '최근 대여 내역',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (viewModel.recentRentals.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('최근 대여 내역이 없습니다.'),
          )
        else
          ...viewModel.recentRentals.map((rental) => Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.systemGrey5,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.id,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '대여 시간: ${rental.startTime.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              )),
      ]),
    );
  }

  Widget _buildNearbyStations(BuildContext context, HomeViewModel viewModel) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '주변 스테이션',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (viewModel.nearbyStations.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('주변에 스테이션이 없습니다.'),
          )
        else
          ...viewModel.nearbyStations.map((station) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.rental,
                    arguments: station,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.systemGrey5,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        station.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      ]),
    );
  }
}
