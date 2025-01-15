import 'package:flutter/cupertino.dart';
import '../../app/routes.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed(Routes.home);
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed(Routes.rental);
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed(Routes.mypage);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.cube_box),
          label: '대여',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person),
          label: '마이페이지',
        ),
      ],
    );
  }
}
