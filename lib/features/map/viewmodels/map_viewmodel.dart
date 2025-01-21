import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../../data/models/station.dart';
import '../../../data/models/accessory.dart';
import '../../../data/repositories/station_repository.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/storage_service.dart';

class MapViewModel with ChangeNotifier {
  final StationRepository _stationRepository;
  final LocationService _locationService;
  final StorageService _storageService;

  List<NMarker> _markers = [];
  Position? _currentPosition;
  Station? _selectedStation;
  bool _isLoading = false;
  String? _error;
  NaverMapController? _mapController;
  NLocationOverlay? _locationOverlay;

  MapViewModel({
    StationRepository? stationRepository,
    LocationService? locationService,
    StorageService? storageService,
  })  : _stationRepository = stationRepository ?? StationRepository.instance,
        _locationService = locationService ?? LocationService.instance,
        _storageService = storageService ?? StorageService.instance;

  List<NMarker> get naverMarkers => _markers;
  Position? get currentLocation => _currentPosition;
  Station? get selectedStation => _selectedStation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void onMapCreated(NaverMapController controller) async {
    _mapController = controller;
    _locationOverlay = await controller.getLocationOverlay();

    // 현재 위치로 이동
    if (_currentPosition != null) {
      await _mapController?.updateCamera(
        NCameraUpdate.withParams(
          target:
              NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15,
        ),
      );
    }

    // 마커 추가
    if (_markers.isNotEmpty) {
      await _mapController?.addOverlayAll(_markers.toSet());
    }

    // 스테이션 로드
    _loadStations();
  }

  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 현재 위치를 먼저 가져옴
      await _getCurrentLocation();

      // 저장된 스테이션 정보 불러오기
      _selectedStation = await _storageService.getSelectedStation();
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
      if (_locationOverlay != null) {
        _locationOverlay!.setPosition(
          NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        );
        _locationOverlay!.setIsVisible(true);

        if (_mapController != null) {
          await _mapController!.updateCamera(
            NCameraUpdate.withParams(
              target: NLatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 15,
            ),
          );
        }
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

  Future<void> _selectStation(Station station) async {
    _selectedStation = station;
    // 선택한 스테이션 정보 저장
    await _storageService.setSelectedStation(station);
    if (_mapController != null) {
      await _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(station.latitude, station.longitude),
          zoom: 15,
        ),
      );
    }
    notifyListeners();
  }

  Future<void> moveToCurrentLocation() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
    } else if (_mapController != null) {
      await _mapController!.updateCamera(
        NCameraUpdate.withParams(
          target:
              NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15,
        ),
      );
    }
  }

  Future<Accessory?> getSelectedAccessory() async {
    return await _storageService.getSelectedAccessory();
  }

  void clearSelectedStation() {
    _selectedStation = null;
    _storageService.clearSelections();
    notifyListeners();
  }
}
