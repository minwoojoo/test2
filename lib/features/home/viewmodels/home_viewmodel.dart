import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/rental.dart';
import '../../../data/models/station.dart';
import '../../../data/models/notice.dart';
import '../../../data/repositories/rental_repository.dart';
import '../../../data/repositories/station_repository.dart';
import '../../../data/repositories/notice_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/location_service.dart';

class HomeViewModel extends ChangeNotifier {
  final RentalRepository _rentalRepository;
  final StationRepository _stationRepository;
  final NoticeRepository _noticeRepository;
  final AuthService _authService;
  final LocationService _locationService;

  List<Rental> _activeRentals = [];
  List<Rental> _recentRentals = [];
  List<Station> _nearbyStations = [];
  List<Notice> _notices = [];
  Notice? _latestNotice;
  bool _isLoading = false;
  String? _error;
  bool _hasLocationPermission = false;
  bool _hasShownPermissionDialog = false;

  HomeViewModel({
    RentalRepository? rentalRepository,
    StationRepository? stationRepository,
    NoticeRepository? noticeRepository,
    AuthService? authService,
    LocationService? locationService,
  })  : _rentalRepository = rentalRepository ?? RentalRepository(),
        _stationRepository = stationRepository ?? StationRepository(),
        _noticeRepository = noticeRepository ?? NoticeRepository(),
        _authService = authService ?? AuthService.instance,
        _locationService = locationService ?? LocationService.instance {
    loadHomeData();
  }

  List<Rental> get activeRentals => _activeRentals;
  List<Rental> get recentRentals => _recentRentals;
  List<Station> get nearbyStations => _nearbyStations;
  List<Notice> get notices => _notices;
  Notice? get latestNotice => _latestNotice;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocationPermission => _hasLocationPermission;
  bool get hasShownPermissionDialog => _hasShownPermissionDialog;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = _authService.currentUser?.id;
      if (userId != null) {
        await Future.wait([
          _loadActiveRentals(userId),
          _loadRecentRentals(userId),
          _loadNearbyStations(),
          _loadNotices(),
        ]);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadActiveRentals(String userId) async {
    _activeRentals = await _rentalRepository.getActiveRentals(userId);
  }

  Future<void> _loadRecentRentals(String userId) async {
    _recentRentals = await _rentalRepository.getRecentRentals(userId);
  }

  Future<void> _loadNearbyStations() async {
    _hasLocationPermission = await _locationService.requestPermission();
    if (!_hasLocationPermission) {
      _nearbyStations = await _stationRepository.getAll();
      return;
    }

    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      _nearbyStations = await _stationRepository.getNearbyStations(
        position.latitude,
        position.longitude,
        radius: 5.0,
      );
    } else {
      _nearbyStations = await _stationRepository.getAll();
    }
  }

  Future<void> _loadNotices() async {
    _notices = await _noticeRepository.getAll();
    _latestNotice = _notices.isNotEmpty ? _notices.first : null;
  }

  Future<void> refresh() async {
    await loadHomeData();
  }

  Future<void> requestLocationPermission() async {
    _hasLocationPermission = await _locationService.requestPermission();
    if (_hasLocationPermission) {
      await _loadNearbyStations();
    }
    notifyListeners();
  }

  void setPermissionDialogShown() {
    _hasShownPermissionDialog = true;
    notifyListeners();
  }
}
