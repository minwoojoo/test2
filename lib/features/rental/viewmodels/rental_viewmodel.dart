import 'package:flutter/foundation.dart';
import '../../../data/models/accessory.dart';
import '../../../data/models/station.dart';
import '../../../data/repositories/accessory_repository.dart';
import '../../../data/repositories/station_repository.dart';
import '../../../core/services/storage_service.dart';

class RentalViewModel extends ChangeNotifier {
  final AccessoryRepository _accessoryRepository = AccessoryRepository();
  final StationRepository _stationRepository = StationRepository.instance;
  final StorageService _storageService = StorageService.instance;

  List<Accessory> _accessories = [];
  List<Accessory> _filteredAccessories = [];
  String _selectedCategory = '';
  String _searchQuery = '';
  final List<Station> _stations = [
    Station(
      id: 'S1',
      name: '강남역점',
      address: '서울특별시 강남구 강남대로 396',
      isActive: true,
    ),
    Station(
      id: 'S2',
      name: '홍대입구역점',
      address: '서울특별시 마포구 홍대로 123',
      isActive: true,
    ),
    Station(
      id: 'S3',
      name: '명동점',
      address: '서울특별시 중구 명동길 45',
      isActive: true,
    ),
    Station(
      id: 'S4',
      name: '여의도역점',
      address: '서울특별시 영등포구 여의도로 789',
      isActive: true,
    ),
  ];
  Station? _selectedStation;
  Accessory? _selectedAccessory;
  bool _isLoading = false;
  String? _error;

  List<Accessory> get accessories => _accessories;
  List<Station> get stations => _stations;
  Station? get selectedStation => _selectedStation;
  Accessory? get selectedAccessory => _selectedAccessory;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RentalViewModel() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // AccessoryRepository에서 모든 악세사리 데이터 가져오기
      _accessories = await _accessoryRepository.getAll();
      _filteredAccessories = _accessories;

      // 저장된 스테이션 정보 불러오기
      _selectedStation = await _storageService.getSelectedStation();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectStation(Station station) async {
    _selectedStation = station;
    await _storageService.setSelectedStation(station);
    notifyListeners();
  }

  Future<void> selectAccessory(Accessory accessory) async {
    _selectedAccessory = accessory;
    await _storageService.setSelectedAccessory(accessory);
    notifyListeners();
  }

  Future<void> clearSelections() async {
    _selectedStation = null;
    _selectedAccessory = null;
    await _storageService.clearSelections();
    notifyListeners();
  }

  List<Accessory> get filteredAccessories => _filteredAccessories;

  void selectCategory(String category) {
    _selectedCategory = category;
    _filterAccessories();
    notifyListeners();
  }

  void searchAccessories(String query) {
    _searchQuery = query;
    _filterAccessories();
    notifyListeners();
  }

  void _filterAccessories() {
    _filteredAccessories = _accessories.where((accessory) {
      bool categoryMatch = _selectedCategory.isEmpty ||
          accessory.category.toString() == _selectedCategory;
      bool searchMatch = _searchQuery.isEmpty ||
          accessory.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();
  }

  Future<void> refresh() async {
    await _init();
  }
}
