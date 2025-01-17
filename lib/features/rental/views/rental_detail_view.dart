import 'package:flutter/material.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../app/routes.dart';
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
      MaterialPageRoute(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 정보'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Colors.grey[200],
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
                          Text(
                            widget.accessory.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.accessory.pricePerHour}원/시간',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.accessory.isAvailable ? '대여 가능' : '대여 불가',
                            style: TextStyle(
                              color: widget.accessory.isAvailable
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '대여 시간',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListWheelScrollView(
                              itemExtent: 40,
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
                          Text(
                            '스테이션 정보',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          if (_selectedStation != null)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey[300]!,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _selectedStation!.address,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              child: TextButton(
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
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
