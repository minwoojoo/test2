import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import '../../../app/routes.dart';
import '../viewmodels/mypage_viewmodel.dart';
import 'package:provider/provider.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyPageViewModel(),
      child: const _MyPageContent(),
    );
  }
}

class _MyPageContent extends StatelessWidget {
  const _MyPageContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('마이페이지'),
            ),
            child: SafeArea(
              child: Consumer<MyPageViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  if (viewModel.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            viewModel.error!,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          CupertinoButton(
                            onPressed: viewModel.loadUser,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    );
                  }

                  final user = viewModel.user;
                  if (user == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '로그인이 필요합니다.',
                            style: AppTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          CupertinoButton.filled(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.login);
                            },
                            child: const Text('로그인'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user.profileImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: AppTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.editProfile);
                              },
                              child: const Icon(
                                CupertinoIcons.pencil,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildSection(
                          title: '대여 현황',
                          child: user.rentals.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      '대여 중인 물품이 없습니다.',
                                      style: AppTheme.bodyMedium,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: user.rentals
                                      .map((rental) => _buildRentalItem(rental))
                                      .toList(),
                                ),
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          title: '최근 이용 내역',
                          child: user.rentals.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      '최근 이용 내역이 없습니다.',
                                      style: AppTheme.bodyMedium,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: user.rentals
                                      .map((rental) => _buildRentalItem(rental))
                                      .toList(),
                                ),
                        ),
                        const SizedBox(height: 32),
                        CupertinoButton(
                          onPressed: () async {
                            await AuthService.instance.signOut();
                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.login);
                            }
                          },
                          child: const Text('로그아웃'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const AppBottomNavigationBar(currentIndex: 2),
      ],
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
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildRentalItem(dynamic rental) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lightGrey,
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
                  rental.accessoryId, // TODO: 실제 액세서리 이름으로 변경
                  style: AppTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  rental.stationId, // TODO: 실제 스테이션 이름으로 변경
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${rental.totalPrice}원',
                style: AppTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                rental.status.toString(), // TODO: 상태 텍스트로 변경
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
