import 'package:flutter/foundation.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../data/repositories/accessory_repository.dart';
import '../../../data/repositories/station_repository.dart';

class RentalViewModel extends ChangeNotifier {
  final AccessoryRepository _accessoryRepository;
  final StationRepository _stationRepository;

  List<Accessory> _accessories = [];
  List<Station> _stations = [];
  Station? _selectedStation;
  Accessory? _selectedAccessory;
  AccessoryCategory? _selectedCategory;
  bool _isLoading = true;
  String? _error;

  RentalViewModel({
    AccessoryRepository? accessoryRepository,
    StationRepository? stationRepository,
  })  : _accessoryRepository = accessoryRepository ?? AccessoryRepository(),
        _stationRepository = stationRepository ?? StationRepository.instance {
    _init();
  }

  List<Accessory> get accessories => _accessories;
  List<Station> get stations => _stations;
  Station? get selectedStation => _selectedStation;
  Accessory? get selectedAccessory => _selectedAccessory;
  AccessoryCategory? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Accessory> get filteredAccessories {
    if (_selectedCategory == null) return _accessories;
    return _accessories
        .where((accessory) => accessory.category == _selectedCategory)
        .toList();
  }

  Future<void> _init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadAccessories(),
        _loadStations(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAccessories() async {
    _accessories = await _accessoryRepository.getAll();
  }

  Future<void> _loadStations() async {
    _stations = await _stationRepository.getNearbyStations();
  }

  void selectStation(Station station) {
    _selectedStation = station;
    notifyListeners();
  }

  void selectAccessory(Accessory accessory) {
    _selectedAccessory = accessory;
    notifyListeners();
  }

  void selectCategory(AccessoryCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> refresh() => _init();
}
