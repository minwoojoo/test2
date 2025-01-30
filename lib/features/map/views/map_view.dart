import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import '../../../data/models/station.dart';

class MapView extends StatelessWidget {
  final bool isPreview;
  final List<Station> stations;

  const MapView({
    super.key,
    this.isPreview = false,
    this.stations = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isPreview
          ? null
          : AppBar(
              title: const Text('주변 스테이션'),
              centerTitle: true,
            ),
      body: ListView.builder(
        itemCount: stations.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final station = stations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(station.name),
              subtitle: Text(station.address),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context, station);
              },
            ),
          );
        },
      ),
      bottomNavigationBar:
          isPreview ? null : const AppBottomNavigationBar(currentIndex: 1),
    );
  }
}
