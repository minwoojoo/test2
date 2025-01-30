import 'package:flutter/material.dart';
import '../../data/models/station.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatelessWidget {
  final bool isPreview;
  final Position? initialPosition;
  final List<Station> stations;

  const MapView({
    super.key,
    this.isPreview = false,
    this.initialPosition,
    this.stations = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              '${stations.length}개의 스테이션',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              '터치하여 자세히 보기',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
