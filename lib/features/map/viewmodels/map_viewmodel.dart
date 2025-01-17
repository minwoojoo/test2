import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/station.dart';
import '../../../data/repositories/station_repository.dart';
import '../../../core/services/location_service.dart';

class MapViewModel with ChangeNotifier {
  final StationRepository _stationRepository;
  final LocationService _locationService;

  Set<Marker> _markers = {};
  Position? _currentPosition;
  Station? _selectedStation;
  bool _isLoading = false;
  String? _error;

  MapViewModel({
    StationRepository? stationRepository,
    LocationService? locationService,
  })  : _stationRepository = stationRepository ?? StationRepository.instance,
        _locationService = locationService ?? LocationService.instance;

  Set<Marker> get markers => _markers;
  Position? get currentPosition => _currentPosition;
  Station? get selectedStation => _selectedStation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _getCurrentLocation();
      await _loadStations();
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
      notifyListeners();
    }
  }

  Future<void> _loadStations() async {
    if (_currentPosition == null) return;

    try {
      final stations = await _stationRepository.getNearbyStations();

      _markers = stations.map((station) {
        return Marker(
          markerId: MarkerId(station.id),
          position: LatLng(station.latitude, station.longitude),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: station.address,
          ),
          onTap: () => _selectStation(station),
        );
      }).toSet();

      notifyListeners();
    } catch (e) {
      print('Failed to load stations: $e');
    }
  }

  void _selectStation(Station station) {
    _selectedStation = station;
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    await _getCurrentLocation();
    await _loadStations();
  }

  void clearSelectedStation() {
    _selectedStation = null;
    notifyListeners();
  }

  CameraPosition get initialCameraPosition {
    if (_currentPosition != null) {
      return CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 14,
      );
    }
    // 서울 시청 좌표를 기본값으로 사용
    return const CameraPosition(
      target: LatLng(37.5665, 126.9780),
      zoom: 14,
    );
  }
}
