import 'package:flutter/foundation.dart';
import '../../../data/models/station.dart';
import '../../../data/models/rental.dart';
import '../../../data/models/notice.dart';
import '../../../data/repositories/station_repository.dart';
import '../../../data/repositories/rental_repository.dart';
import '../../../data/repositories/notice_repository.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/auth_service.dart';

class HomeViewModel extends ChangeNotifier {
  final StationRepository _stationRepository;
  final RentalRepository _rentalRepository;
  final NoticeRepository _noticeRepository;
  final LocationService _locationService;
  final AuthService _authService;

  List<Station> _nearbyStations = [];
  List<Rental> _recentRentals = [];
  List<Rental> _activeRentals = [];
  List<Notice> _notices = [];
  Notice? _latestNotice;
  bool _isLoading = false;
  String? _error;
  bool _hasLocationPermission = false;

  HomeViewModel({
    StationRepository? stationRepository,
    RentalRepository? rentalRepository,
    NoticeRepository? noticeRepository,
    LocationService? locationService,
    AuthService? authService,
  })  : _stationRepository = stationRepository ?? StationRepository(),
        _rentalRepository = rentalRepository ?? RentalRepository(),
        _noticeRepository = noticeRepository ?? NoticeRepository(),
        _locationService = locationService ?? LocationService.instance,
        _authService = authService ?? AuthService.instance {
    _init();
  }

  List<Station> get nearbyStations => _nearbyStations;
  List<Rental> get recentRentals => _recentRentals;
  List<Rental> get activeRentals => _activeRentals;
  Notice? get latestNotice => _latestNotice;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocationPermission => _hasLocationPermission;

  Future<void> _init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _checkLocationPermission();
      await Future.wait([
        _loadNearbyStations(),
        _loadRentals(),
        _loadNotices(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkLocationPermission() async {
    _hasLocationPermission = await _locationService.requestPermission();
    notifyListeners();
  }

  Future<bool> requestLocationPermission() async {
    _hasLocationPermission = await _locationService.requestPermission();
    if (_hasLocationPermission) {
      await _loadNearbyStations();
    }
    notifyListeners();
    return _hasLocationPermission;
  }

  Future<void> _loadNearbyStations() async {
    if (!_hasLocationPermission) {
      _nearbyStations = [];
      return;
    }

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _nearbyStations = await _stationRepository.getNearbyStations(
          position.latitude,
          position.longitude,
          radius: 5.0, // 5km 반경
        );
      }
    } catch (e) {
      print('Failed to load nearby stations: $e');
      _nearbyStations = [];
    }
  }

  Future<void> _loadRentals() async {
    try {
      final userId = _authService.currentUser?.id;
      if (userId != null) {
        _activeRentals = await _rentalRepository.getActiveRentals(userId);
        _recentRentals = await _rentalRepository.getRecentRentals(userId);
      }
    } catch (e) {
      print('Failed to load rentals: $e');
      _activeRentals = [];
      _recentRentals = [];
    }
  }

  Future<void> _loadNotices() async {
    try {
      _notices = await _noticeRepository.getAll();
      _latestNotice = _notices.isNotEmpty ? _notices.first : null;
    } catch (e) {
      print('Failed to load notices: $e');
      _notices = [];
      _latestNotice = null;
    }
  }

  Future<void> refresh() async {
    await _init();
  }
}
