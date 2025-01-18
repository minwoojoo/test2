import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../services/auth_service.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
            final user = AuthService.instance.currentUser;
            if (user?.email != null) {
              Navigator.of(context).pushReplacementNamed(Routes.mypage);
            } else {
              Navigator.of(context).pushReplacementNamed(Routes.login);
            }
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2),
          label: '대여',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '마이페이지',
        ),
      ],
    );
  }
}
