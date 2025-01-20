import 'package:flutter/material.dart';
import '../../../data/models/rental.dart';
import '../../../data/repositories/rental_repository.dart';
import '../../../core/constants/app_theme.dart';

class RentalHistoryView extends StatefulWidget {
  const RentalHistoryView({super.key});

  @override
  State<RentalHistoryView> createState() => _RentalHistoryViewState();
}

class _RentalHistoryViewState extends State<RentalHistoryView> {
  final _rentalRepository = RentalRepository.instance;
  List<Rental> _activeRentals = [];
  List<Rental> _recentRentals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRentals();
  }

  Future<void> _loadRentals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final activeRentals = await _rentalRepository.getActiveRentals();
      final recentRentals = await _rentalRepository.getRecentRentals();

      setState(() {
        _activeRentals = activeRentals;
        _recentRentals = recentRentals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('대여 내역을 불러오는데 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용 내역'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRentals,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  if (_activeRentals.isNotEmpty) ...[
                    Text('현재 대여 중', style: AppTheme.titleMedium),
                    const SizedBox(height: 8),
                    ..._activeRentals.map((rental) => _buildRentalCard(rental)),
                    const SizedBox(height: 24),
                  ],
                  Text('지난 대여 내역', style: AppTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (_recentRentals.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('아직 대여 내역이 없습니다'),
                      ),
                    )
                  else
                    ..._recentRentals.map((rental) => _buildRentalCard(rental)),
                ],
              ),
            ),
    );
  }

  Widget _buildRentalCard(Rental rental) {
    final isActive = rental.status == RentalStatus.active;
    final statusText = isActive ? '대여 중' : '반납 완료';
    final statusColor = isActive ? Colors.blue : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rental.accessoryName,
                    style: AppTheme.titleSmall,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('스테이션: ${rental.stationName}'),
            const SizedBox(height: 4),
            Text('대여 시간: ${rental.formattedRentalTime}'),
            const SizedBox(height: 4),
            Text('결제 금액: ${rental.totalPrice}원'),
          ],
        ),
      ),
    );
  }
}
