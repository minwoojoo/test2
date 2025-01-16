import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/widgets/loading_animation.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import '../../../core/services/auth_service.dart';
import '../../../app/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _error = '이메일과 비밀번호를 입력해주세요.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await AuthService.instance.signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    } catch (e) {
      setState(() {
        _error = '로그인에 실패했습니다. 이메일과 비밀번호를 확인해주세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('로그인'),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Bannabee',
                    style: AppTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  CupertinoTextField(
                    controller: _emailController,
                    placeholder: '이메일',
                    keyboardType: TextInputType.emailAddress,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _passwordController,
                    placeholder: '비밀번호',
                    obscureText: true,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    autocorrect: false,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const HoneyLoadingAnimation(isStationSelected: false)
                  else
                    CupertinoButton.filled(
                      onPressed: _login,
                      child: const Text('로그인'),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.terms);
                        },
                        child: const Text('이메일 가입'),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        color: AppColors.lightGrey,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          // TODO: 이메일 찾기 페이지로 이동
                        },
                        child: const Text('이메일 찾기'),
                      ),
                      Container(
                        width: 1,
                        height: 12,
                        color: AppColors.lightGrey,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          // TODO: 비밀번호 찾기 페이지로 이동
                        },
                        child: const Text('비밀번호 찾기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: const AppBottomNavigationBar(currentIndex: 2),
            ),
          ],
        ),
      ),
    );
  }
}
