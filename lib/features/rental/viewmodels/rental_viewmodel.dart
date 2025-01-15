import 'package:flutter/foundation.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../data/repositories/accessory_repository.dart';
import '../../../data/repositories/station_repository.dart';

class RentalViewModel extends ChangeNotifier {
  final AccessoryRepository _accessoryRepository;
  final StationRepository _stationRepository;

  List<Accessory> _accessories = [];
  List<Station> _nearbyStations = [];
  AccessoryCategory _selectedCategory = AccessoryCategory.charger;
  Accessory? _selectedAccessory;
  Station? _selectedStation;
  bool _isLoading = false;
  String? _error;

  RentalViewModel({
    AccessoryRepository? accessoryRepository,
    StationRepository? stationRepository,
    Station? initialStation,
  })  : _accessoryRepository = accessoryRepository ?? AccessoryRepository(),
        _stationRepository = stationRepository ?? StationRepository(),
        _selectedStation = initialStation {
    loadAccessories();
    if (initialStation == null) {
      loadNearbyStations();
    }
  }

  List<Accessory> get accessories => _accessories;
  List<Station> get nearbyStations => _nearbyStations;
  List<Accessory> get filteredAccessories => _accessories
      .where((a) => a.category == _selectedCategory && a.isAvailable)
      .toList();
  AccessoryCategory get selectedCategory => _selectedCategory;
  Accessory? get selectedAccessory => _selectedAccessory;
  Station? get selectedStation => _selectedStation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get canProceedToPayment =>
      _selectedAccessory != null && _selectedStation != null;

  Future<void> loadAccessories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _accessories = await _accessoryRepository.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNearbyStations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 실제로는 현재 위치를 기반으로 주변 스테이션을 로드해야 함
      _nearbyStations = await _stationRepository.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(AccessoryCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectAccessory(Accessory accessory) {
    _selectedAccessory = accessory;
    notifyListeners();
  }

  void selectStation(Station station) {
    _selectedStation = station;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadAccessories();
    if (_selectedStation == null) {
      await loadNearbyStations();
    }
  }

  void reset() {
    _selectedAccessory = null;
    _selectedStation = null;
    notifyListeners();
  }
}
