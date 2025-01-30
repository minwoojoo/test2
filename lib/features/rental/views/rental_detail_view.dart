import 'package:flutter/material.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../app/routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import '../viewmodels/rental_viewmodel.dart';
import '../../../features/station/views/station_selection_bottom_sheet.dart';
import 'package:provider/provider.dart';

class RentalDetailView extends StatefulWidget {
  final Accessory accessory;
  final Station? station;

  const RentalDetailView({
    Key? key,
    required this.accessory,
    this.station,
  }) : super(key: key);

  @override
  State<RentalDetailView> createState() => _RentalDetailViewState();
}

class _RentalDetailViewState extends State<RentalDetailView> {
  final _storageService = StorageService.instance;
  Station? _selectedStation;
  int _selectedHours = 1;

  @override
  void initState() {
    super.initState();
    _selectedStation = widget.station;
    _loadSelectedStation();
  }

  Future<void> _loadSelectedStation() async {
    if (_selectedStation != null) return;

    final savedStation = await _storageService.getSelectedStation();
    if (savedStation != null) {
      setState(() {
        _selectedStation = savedStation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RentalViewModel(),
      child: Consumer<RentalViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('대여 상세'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${widget.accessory.pricePerHour}원/시간',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.accessory.isAvailable
                                        ? '대여 가능'
                                        : '대여 불가',
                                    style: TextStyle(
                                      color: widget.accessory.isAvailable
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    '대여 시간',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '선택된 시간',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            Text(
                                              '$_selectedHours시간',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: _selectedHours > 1
                                                  ? () {
                                                      setState(() {
                                                        _selectedHours--;
                                                      });
                                                    }
                                                  : null,
                                              icon: const Icon(
                                                  Icons.remove_circle_outline),
                                            ),
                                            Expanded(
                                              child: Slider(
                                                value:
                                                    _selectedHours.toDouble(),
                                                min: 1,
                                                max: 24,
                                                divisions: 23,
                                                label: '$_selectedHours시간',
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedHours =
                                                        value.toInt();
                                                  });
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _selectedHours < 24
                                                  ? () {
                                                      setState(() {
                                                        _selectedHours++;
                                                      });
                                                    }
                                                  : null,
                                              icon: const Icon(
                                                  Icons.add_circle_outline),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '시간당 가격',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '${widget.accessory.pricePerHour}원',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '총 대여 시간',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '$_selectedHours시간',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '총 결제 금액',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${widget.accessory.pricePerHour * _selectedHours}원',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    '스테이션 정보',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '스테이션 정보',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        if (viewModel.selectedStation !=
                                            null) ...[
                                          Text(
                                            viewModel.selectedStation!.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            viewModel.selectedStation!.address,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StationSelectionBottomSheet(
                                                    stations:
                                                        viewModel.stations,
                                                    selectedStation: viewModel
                                                        .selectedStation,
                                                    onStationSelected:
                                                        viewModel.selectStation,
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                            ),
                                            child: const Text('스테이션 선택'),
                                          ),
                                        ),
                                      ],
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: viewModel.selectedStation == null
                                ? null
                                : () {
                                    Navigator.of(context).pushNamed(
                                      Routes.payment,
                                      arguments: {
                                        'accessory': widget.accessory,
                                        'station': viewModel.selectedStation,
                                        'hours': _selectedHours,
                                      },
                                    );
                                  },
                            child: Text(
                              viewModel.selectedStation == null
                                  ? '스테이션을 선택해주세요'
                                  : '결제하기',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
          );
        },
      ),
    );
  }
}

class StationSelectionBottomSheet extends StatelessWidget {
  final List<Station> stations;
  final Station? selectedStation;
  final Function(Station) onStationSelected;

  const StationSelectionBottomSheet({
    super.key,
    required this.stations,
    this.selectedStation,
    required this.onStationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AlertDialog(
        title: const Text(
          '스테이션 선택',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    final isSelected = selectedStation?.id == station.id;

                    return ListTile(
                      title: Text(
                        station.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(station.address),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        onStationSelected(station);
                        Navigator.pop(context); // 선택 후 다이얼로그 닫기
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
