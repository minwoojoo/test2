import 'package:flutter/material.dart';
import '../../../core/models/rental.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/rental_service.dart';
import '../../../app/routes.dart';
import '../../../core/constants/app_theme.dart';

class RentalHistoryView extends StatelessWidget {
  const RentalHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용 내역'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Rental>>(
        future: RentalService.instance.getRentalHistory(
          AuthService.instance.currentUser?.id ?? '',
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }

          final rentals = snapshot.data ?? [];

          if (rentals.isEmpty) {
            return const Center(child: Text('이용 내역이 없습니다.'));
          }

          return ListView.builder(
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rental.accessoryName,
                        style: AppTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rental.stationName,
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rental.formattedRentalTime,
                        style: AppTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '총 결제 금액: ${rental.totalPrice}원',
                        style: AppTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '대여 상태: ${rental.status.name}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: rental.status == RentalStatus.active
                              ? Colors.blue
                              : rental.status == RentalStatus.completed
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              Routes.rental,
                              arguments: {
                                'accessoryId': rental.accessoryId,
                                'stationId': rental.stationId,
                              },
                            );
                          },
                          child: const Text('같은 조건으로 대여하기'),
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
