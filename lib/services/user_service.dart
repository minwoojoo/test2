import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUserDocument({
    required String email,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      // 새로운 문서 생성 (자동 ID 생성)
      DocumentReference newUserRef = _usersCollection.doc();
      String userId = newUserRef.id;

      // 사용자 데이터 생성
      final userData = {
        'available_time': -1,
        'createdAt': FieldValue.serverTimestamp(),
        'email': email,
        'id': userId, // 문서 ID와 동일한 값
        'name': name,
        'phoneNumber': phoneNumber,
        'profileImageUrl': null,
        'rentalHistory': [],
      };

      // Firestore에 데이터 저장
      await newUserRef.set(userData);
    } catch (e) {
      print('사용자 문서 생성 중 오류 발생: $e');
      rethrow;
    }
  }
}
