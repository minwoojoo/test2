import 'package:flutter/cupertino.dart';
import 'app/routes.dart';
import 'core/services/auth_service.dart';
import 'data/models/rental.dart';
import 'features/auth/views/login_view.dart';
import 'features/auth/views/signup_complete_view.dart';
import 'features/auth/views/signup_view.dart';
import 'features/auth/views/terms_view.dart';
import 'features/home/views/home_view.dart';
import 'features/map/views/map_view.dart';
import 'features/mypage/views/edit_profile_view.dart';
import 'features/mypage/views/mypage_view.dart';
import 'features/payment/views/payment_complete_view.dart';
import 'features/payment/views/payment_view.dart';
import 'features/rental/views/rental_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Bannabee',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => const HomeView(),
        Routes.map: (context) => const MapView(),
        Routes.rental: (context) => const RentalView(),
        Routes.payment: (context) => PaymentView(
              rental: ModalRoute.of(context)!.settings.arguments as Rental,
            ),
        Routes.paymentComplete: (context) => PaymentCompleteView(
              rental: ModalRoute.of(context)!.settings.arguments as Rental,
            ),
        Routes.mypage: (context) => const MyPageView(),
        Routes.editProfile: (context) => const EditProfileView(),
        Routes.login: (context) => const LoginView(),
        Routes.terms: (context) => const TermsView(),
        Routes.signup: (context) => const SignupView(),
        Routes.signupComplete: (context) => const SignupCompleteView(),
      },
    );
  }
}
