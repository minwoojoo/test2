import 'package:flutter/cupertino.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../app/routes.dart';

class RentalDetailView extends StatelessWidget {
  final Accessory accessory;
  final Station? station;

  const RentalDetailView({
    super.key,
    required this.accessory,
    this.station,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('상세 정보'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 이미지
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: CupertinoColors.systemGrey6,
                        child: Image.asset(
                          accessory.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 이름
                          Text(
                            accessory.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 가격
                          Text(
                            '${accessory.pricePerHour}원/시간',
                            style: const TextStyle(
                              fontSize: 18,
                              color: CupertinoColors.activeBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 설명
                          const Text(
                            '상세 설명',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            accessory.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          if (station != null) ...[
                            const SizedBox(height: 24),
                            const Text(
                              '대여 위치',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: CupertinoColors.systemGrey5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          station!.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          station!.address,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        Routes.map,
                                        arguments: {'fromRental': true},
                                      );
                                    },
                                    child: const Text('변경'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {
                    if (station == null) {
                      Navigator.of(context).pushNamed(
                        Routes.rental,
                        arguments: null,
                      );
                    } else {
                      Navigator.of(context).pushNamed(
                        Routes.payment,
                        arguments: {
                          'accessory': accessory,
                          'station': station,
                        },
                      );
                    }
                  },
                  child: Text(
                    station == null ? '스테이션 선택' : '결제하기',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
