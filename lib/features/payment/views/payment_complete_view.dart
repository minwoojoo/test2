import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../../data/models/rental.dart';
import '../../../app/routes.dart';

class PaymentCompleteView extends StatelessWidget {
  final Rental rental;

  const PaymentCompleteView({
    super.key,
    required this.rental,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🩷', style: TextStyle(fontSize: 50)),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/payment_complete.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 16),
                  const Text('🩷', style: TextStyle(fontSize: 50)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '결제가 완료되었습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 56,
                child: CupertinoButton.filled(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  },
                  child: const Text('홈으로 돌아가기'),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
