import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/user_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Firebase Auth로 계정 생성
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Firestore에 사용자 문서 생성
      if (userCredential.user != null) {
        await _userService.createUserDocument(
          email: email,
          name: name,
          phoneNumber: phoneNumber,
        );

        print('사용자 문서 생성 완료: ${userCredential.user?.uid}'); // 디버깅용 로그
        return true;
      }

      return false;
    } catch (e) {
      print('회원가입 중 오류 발생: $e'); // 디버깅용 로그
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
