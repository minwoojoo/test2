/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

// 사용자가 생성될 때 자동으로 실행되는 함수
exports.onUserCreated = functions.auth.user().onCreate(async (userRecord) => {
  try {
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      available_time: -1,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      email: userRecord.email,
      id: userRecord.uid,
      name: userRecord.displayName || '',
      phoneNumber: userRecord.phoneNumber || '',
      profileImageUrl: userRecord.photoURL || null,
      rentalHistory: [],
    });
  } catch (error) {
    console.error('Error creating user document:', error);
  }
});

// HTTP 호출 가능한 함수 예시
exports.getUserRentalHistory = functions.https.onCall(async (data, context) => {
  // 인증 확인
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', '인증이 필요합니다.');
  }

  try {
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(context.auth.uid)
      .get();
    
    const userData = userDoc.data();
    return {
      rentalHistory: userData ? userData.rentalHistory || [] : []
    };
  } catch (error) {
    throw new functions.https.HttpsError('internal', '데이터 조회 중 오류가 발생했습니다.');
  }
});

// Firestore 트리거 함수 예시
exports.onRentalHistoryUpdate = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    const newData = change.after.data();
    const previousData = change.before.data();
    
    // rentalHistory가 변경되었을 때만 실행
    if (JSON.stringify(newData.rentalHistory) !== JSON.stringify(previousData.rentalHistory)) {
      // 알림 보내기 등의 작업 수행
      if (newData.fcmToken) {
        await admin.messaging().sendToDevice(
          [newData.fcmToken], 
          {
            notification: {
              title: '대여 기록 업데이트',
              body: '새로운 대여 기록이 추가되었습니다.',
            }
          }
        );
      }
    }
});

// 정기적인 작업 예시
exports.scheduledFunction = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const usersRef = admin.firestore().collection('users');
    const snapshot = await usersRef.get();
    
    snapshot.forEach(async (doc) => {
      await doc.ref.update({
        available_time: -1  // 매일 초기화
      });
    });
});

// 데이터 검증 예시
exports.validateRental = functions.firestore
  .document('rentals/{rentalId}')
  .onCreate(async (snap, context) => {
    const rentalData = snap.data();
    
    if (!rentalData.userId || !rentalData.accessoryId) {
      await snap.ref.delete();
      throw new Error('필수 필드가 누락되었습니다.');
    }
    
    await admin.firestore()
      .collection('users')
      .doc(rentalData.userId)
      .update({
        rentalHistory: admin.firestore.FieldValue.arrayUnion(rentalData)
      });
});
