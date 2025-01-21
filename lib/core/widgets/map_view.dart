import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../data/models/station.dart';

class MapView extends StatefulWidget {
  final bool isPreview;
  final Function(Station)? onStationSelected;
  final List<Station>? stations;

  const MapView({
    super.key,
    this.isPreview = false,
    this.onStationSelected,
    this.stations,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  NaverMapController? _mapController;
  Set<NMarker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: const NCameraPosition(
          target: NLatLng(37.5666102, 126.9783881),
          zoom: 15,
        ),
      ),
      onMapReady: (controller) {
        _mapController = controller;
        if (widget.stations != null) {
          _addStationMarkers();
        }
      },
    );
  }

  void _addStationMarkers() {
    if (widget.stations == null) return;

    for (final station in widget.stations!) {
      final marker = NMarker(
        id: station.id,
        position: NLatLng(
          station.latitude,
          station.longitude,
        ),
      );

      marker.setOnTapListener((marker) {
        if (widget.onStationSelected != null) {
          final selectedStation = widget.stations!.firstWhere(
            (s) => s.id == marker.info.id,
          );
          widget.onStationSelected!(selectedStation);
        }
      });

      _markers.add(marker);
    }

    _mapController?.addOverlayAll(_markers);
  }
}
