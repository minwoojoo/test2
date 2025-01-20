import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../../data/models/station.dart';
import '../../../data/repositories/station_repository.dart';
import '../../../core/services/location_service.dart';

class MapViewModel with ChangeNotifier {
  final StationRepository _stationRepository;
  final LocationService _locationService;

  List<NMarker> _markers = [];
  Position? _currentPosition;
  Station? _selectedStation;
  bool _isLoading = false;
  String? _error;
  NaverMapController? _mapController;

  MapViewModel({
    StationRepository? stationRepository,
    LocationService? locationService,
  })  : _stationRepository = stationRepository ?? StationRepository.instance,
        _locationService = locationService ?? LocationService.instance;

  List<NMarker> get naverMarkers => _markers;
  Position? get currentLocation => _currentPosition;
  Station? get selectedStation => _selectedStation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void onMapCreated(NaverMapController controller) {
    _mapController = controller;
    if (_markers.isNotEmpty) {
      _mapController?.addOverlayAll(_markers.toSet());
    }
    _loadStations();
  }

  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _getCurrentLocation();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      _currentPosition = position;
      if (_mapController != null) {
        final locationOverlay = await _mapController!.getLocationOverlay();
        locationOverlay.setPosition(
          NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        );
        locationOverlay.setIsVisible(true);
      }
      notifyListeners();
    }
  }

  Future<void> _loadStations() async {
    if (_currentPosition == null) return;

    try {
      final stations = await _stationRepository.getNearbyStations();
      _markers.clear();

      final markerIcon = await NOverlayImage.fromAssetImage(
        'assets/images/honey.png',
      );

      for (final station in stations) {
        final marker = NMarker(
          id: station.id,
          position: NLatLng(station.latitude, station.longitude),
          icon: markerIcon,
          size: const Size(48, 48),
          anchor: const NPoint(0.5, 0.5),
        );

        marker.setOnTapListener((marker) {
          _selectStation(station);
        });

        _markers.add(marker);
      }

      if (_mapController != null) {
        await _mapController!.clearOverlays();
        await _mapController!.addOverlayAll(_markers.toSet());
      }

      notifyListeners();
    } catch (e) {
      print('Failed to load stations: $e');
    }
  }

  void _selectStation(Station station) {
    _selectedStation = station;
    if (_mapController != null) {
      _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(station.latitude, station.longitude),
          zoom: 15,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    await _getCurrentLocation();
    if (_currentPosition != null && _mapController != null) {
      final locationOverlay = await _mapController!.getLocationOverlay();
      locationOverlay.setPosition(
        NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      );
      locationOverlay.setIsVisible(true);

      _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target:
              NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15,
        ),
      );
    }
  }

  void clearSelectedStation() {
    _selectedStation = null;
    notifyListeners();
  }
}
