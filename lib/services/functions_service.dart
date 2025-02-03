import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<List<dynamic>> getUserRentalHistory() async {
    try {
      final result =
          await _functions.httpsCallable('getUserRentalHistory').call();

      return result.data['rentalHistory'] as List<dynamic>;
    } catch (e) {
      print('함수 호출 중 오류 발생: $e');
      rethrow;
    }
  }
}
