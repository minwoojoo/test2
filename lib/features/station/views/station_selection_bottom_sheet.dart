import 'package:flutter/material.dart';
import '../../../data/models/station.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '스테이션 선택',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                  onTap: () => onStationSelected(station),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
