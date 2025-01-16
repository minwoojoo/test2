import 'package:flutter/cupertino.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_theme.dart';
import '../../station/views/station_selection_view.dart';

class RentalDetailView extends StatefulWidget {
  final Accessory accessory;
  final Station? station;

  const RentalDetailView({
    super.key,
    required this.accessory,
    this.station,
  });

  @override
  State<RentalDetailView> createState() => _RentalDetailViewState();
}

class _RentalDetailViewState extends State<RentalDetailView> {
  Station? _selectedStation;
  int _selectedHours = 1;

  @override
  void initState() {
    super.initState();
    _selectedStation = widget.station;
  }

  Future<void> _selectStation() async {
    final station = await Navigator.of(context).push<Station>(
      CupertinoPageRoute(
        builder: (context) => StationSelectionView(
          currentStation: _selectedStation,
        ),
      ),
    );

    if (station != null) {
      setState(() {
        _selectedStation = station;
      });
    }
  }

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
                          widget.accessory.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 상품 정보
                          Text(
                            widget.accessory.name,
                            style: AppTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.accessory.pricePerHour}원/시간',
                            style: AppTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.accessory.isAvailable ? '대여 가능' : '대여 불가',
                            style: AppTheme.bodyMedium.copyWith(
                              color: widget.accessory.isAvailable
                                  ? AppColors.primary
                                  : AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 대여 시간 선택
                          Text(
                            '대여 시간',
                            style: AppTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CupertinoPicker(
                              itemExtent: 32,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  _selectedHours = index + 1;
                                });
                              },
                              children: List.generate(24, (index) {
                                return Center(
                                  child: Text('${index + 1}시간'),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 스테이션 정보
                          Text(
                            '스테이션 정보',
                            style: AppTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          if (_selectedStation != null)
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
                                          _selectedStation!.name,
                                          style: AppTheme.titleSmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _selectedStation!.address,
                                          style: AppTheme.bodySmall.copyWith(
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: _selectStation,
                                    child: const Text('변경'),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: CupertinoColors.systemGrey5,
                                ),
                              ),
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: _selectStation,
                                child: const Text('스테이션 선택'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '총 결제 금액: ${widget.accessory.pricePerHour * _selectedHours}원',
                    style: AppTheme.titleMedium,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: _selectedStation == null
                          ? null
                          : () {
                              Navigator.of(context).pushNamed(
                                Routes.payment,
                                arguments: {
                                  'accessory': widget.accessory,
                                  'station': _selectedStation,
                                  'hours': _selectedHours,
                                },
                              );
                            },
                      child: Text(
                        _selectedStation == null ? '스테이션을 선택해주세요' : '결제하기',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
