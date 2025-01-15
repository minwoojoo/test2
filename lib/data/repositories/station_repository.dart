import '../models/station.dart';

class StationRepository {
  Future<List<Station>> getAll() async {
    // 시뮬레이션을 위한 더미 데이터
    await Future.delayed(const Duration(seconds: 1));
    return [
      Station(
        id: '1',
        name: '강남역 1번 출구',
        address: '서울특별시 강남구 강남대로 396',
        latitude: 37.498095,
        longitude: 127.027610,
      ),
    ];
  }

  Future<Station> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return Station(
      id: id,
      name: '강남역 1번 출구',
      address: '서울특별시 강남구 강남대로 396',
      latitude: 37.498095,
      longitude: 127.027610,
    );
  }

  Future<List<Station>> getNearbyStations(double latitude, double longitude,
      {required double radius}) async {
    // 시뮬레이션을 위한 더미 데이터
    await Future.delayed(const Duration(seconds: 1));
    return [
      Station(
        id: '1',
        name: '강남역 1번 출구',
        address: '서울특별시 강남구 강남대로 396',
        latitude: 37.498095,
        longitude: 127.027610,
      ),
    ];
  }
}
