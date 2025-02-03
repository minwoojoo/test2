import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/routes.dart';
import 'core/constants/app_colors.dart';
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
import 'features/notice/views/notice_list_view.dart';
import 'features/payment/views/payment_complete_view.dart';
import 'features/payment/views/payment_view.dart';
import 'features/rental/views/rental_view.dart';
import 'features/rental/views/rental_status_view.dart';
import 'features/rental/views/rental_history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'features/auth/viewmodels/signup_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bannabee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => const HomeView(),
        Routes.map: (context) => const MapView(),
        Routes.rental: (context) => const RentalView(),
        Routes.rentalStatus: (context) => const RentalStatusView(),
        Routes.rentalHistory: (context) => const RentalHistoryView(),
        Routes.payment: (context) => PaymentView(
              rentalInfo: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
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
        Routes.noticeList: (context) => const NoticeListView(),
      },
    );
  }
}

class FirebaseConfig {
  static const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyAhldvpALpCn26hEEtd5KM51oGNEnzy5yw",
    appId: "1:333666239496:web:ffcc64c061b08332f33dbd",
    messagingSenderId: "333666239496",
    projectId: "bannabee-b15ef",
    storageBucket: "bannabee-b15ef.appspot.com",
    authDomain: "bannabee-b15ef.firebaseapp.com",
  );

  static Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
  }
}

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // 사용자 생성
  Future<void> createUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(userId).set(userData);
    } catch (e) {
      print('사용자 생성 중 오류 발생: $e');
      rethrow;
    }
  }

  // 사용자 조회
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('사용자 조회 중 오류 발생: $e');
      rethrow;
    }
  }

  // 사용자 업데이트
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(userId).update(userData);
    } catch (e) {
      print('사용자 업데이트 중 오류 발생: $e');
      rethrow;
    }
  }

  // 사용자 삭제
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      print('사용자 삭제 중 오류 발생: $e');
      rethrow;
    }
  }

  // 실시간 사용자 데이터 스트림
  Stream<DocumentSnapshot> getUserStream(String userId) {
    return _usersCollection.doc(userId).snapshots();
  }

  // 모든 사용자 실시간 스트림
  Stream<QuerySnapshot> getAllUsersStream() {
    return _usersCollection.snapshots();
  }
}
