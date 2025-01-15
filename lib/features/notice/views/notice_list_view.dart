import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../viewmodels/notice_list_viewmodel.dart';
import '../../../app/routes.dart';

class NoticeListView extends StatelessWidget {
  const NoticeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoticeListViewModel(),
      child: const _NoticeListContent(),
    );
  }
}

class _NoticeListContent extends StatelessWidget {
  const _NoticeListContent();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('공지사항'),
      ),
      child: Consumer<NoticeListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }
          if (viewModel.notices.isEmpty) {
            return const Center(child: Text('공지사항이 없습니다.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.notices.length,
            itemBuilder: (context, index) {
              final notice = viewModel.notices[index];
              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  Routes.noticeDetail,
                  arguments: notice,
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.title,
                        style: AppTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notice.createdAt.toString().split(' ')[0],
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
