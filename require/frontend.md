# Frontend Architecture (프론트엔드 아키텍처)

## MVVM 패턴 구조
- Model: 데이터와 비즈니스 로직을 담당
- View: UI 요소와 사용자 인터페이스를 담당
- ViewModel: View와 Model 사이의 데이터 바인딩과 비즈니스 로직을 담당

## 현재 파일 구조
```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── routes.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_theme.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── location_service.dart
│   │   ├── payment_service.dart
│   │   └── storage_service.dart
│   └── utils/
│       ├── validators.dart
│       └── extensions.dart
├── data/
│   ├── models/
│   │   ├── user.dart
│   │   ├── station.dart
│   │   ├── accessory.dart
│   │   └── rental.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── station_repository.dart
│       ├── accessory_repository.dart
│       └── rental_repository.dart
└── features/
    ├── auth/
    │   ├── views/
    │   │   ├── login_view.dart
    │   │   └── signup_view.dart
    │   └── viewmodels/
    │       ├── login_viewmodel.dart
    │       └── signup_viewmodel.dart
    ├── home/
    │   ├── views/
    │   │   └── home_view.dart
    │   └── viewmodels/
    │       └── home_viewmodel.dart
    ├── map/
    │   ├── views/
    │   │   └── map_view.dart
    │   └── viewmodels/
    │       └── map_viewmodel.dart
    ├── rental/
    │   ├── views/
    │   │   ├── rental_view.dart
    │   │   ├── rental_detail_view.dart
    │   │   └── qr_scan_view.dart
    │   └── viewmodels/
    │       ├── rental_viewmodel.dart
    │       └── rental_detail_viewmodel.dart
    ├── payment/
    │   ├── views/
    │   │   ├── payment_view.dart
    │   │   └── payment_complete_view.dart
    │   └── viewmodels/
    │       └── payment_viewmodel.dart
    └── mypage/
        ├── views/
        │   └── mypage_view.dart
        └── viewmodels/
            └── mypage_viewmodel.dart
```

# 작업 계획 (Implementation Plan)

## Phase 1: 프로젝트 셋업 및 기본 구조 구현 ✅
1. Flutter 프로젝트 생성 및 기본 의존성 설정 ✅
   - 프로젝트 생성
   - pubspec.yaml 의존성 추가
2. 프로젝트 구조 셋업 ✅
   - lib 디렉토리 구조 생성
3. 테마 및 상수 설정 ✅
   - app_colors.dart
   - app_theme.dart
4. 라우팅 시스템 구현 ✅
   - routes.dart
   - main.dart 수정

## Phase 2: 핵심 서비스 구현 ✅
1. 인증 서비스 구현 ✅
   - 로그인/회원가입 기능
   - 소셜 로그인 통합
2. 위치 서비스 구현 ✅
   - 현재 위치 조회
   - 권한 관리
3. 스토리지 서비스 구현 ✅
   - 로컬 데이터 저장
   - 캐시 관리

## Phase 3: 데이터 레이어 구현 ✅
1. 모델 클래스 구현 ✅
   - User 모델
   - Station 모델
   - Accessory 모델
   - Rental 모델
2. Repository 패턴 구현 ✅
   - BaseRepository 인터페이스
   - AuthRepository
   - StationRepository
   - AccessoryRepository
   - RentalRepository
3. API 통신 로직 구현 ✅
   - Dio HTTP 클라이언트 설정
   - API 엔드포인트 연동

## Phase 4: 기능별 UI 및 비즈니스 로직 구현
1. 홈 화면 구현 ✅
   - 검색 기능 ✅
   - 공지사항 표시
   - 대여 현황 표시 ✅
   - 최근 이용 내역 표시 ✅
   - 지도 통합 ✅

2. 지도 기능 구현 ✅
   - 스테이션 마커 표시 ✅
   - 위치 권한 관리 ✅
   - 현재 위치 표시 ✅

3. 대여 기능 구현 ✅
   - 카테고리 필터링 ✅
   - 상품 상세 정보 ✅
   - QR 스캔 통합 ✅

4. 결제 시스템 구현
   - 결제 수단 연동
   - 결제 프로세스
   - 결제 완료 처리

5. 마이페이지 구현
   - 프로필 관리
   - 이용 내역
   - 고객 지원 기능

## Phase 5: 테스트 및 최적화
1. 단위 테스트 작성
2. 통합 테스트 구현
3. UI/UX 최적화
4. 성능 최적화

## Phase 6: 배포 준비
1. 코드 리팩토링
2. 문서화
3. 빌드 및 배포 설정
4. 스토어 등록 준비

## 회원 관리 구현
1. 하단 네비게이션 바의 MY 버튼 클릭시
- 로그인 기록이 쿠키로 존재하지 않는다면, 로그인 페이지 이동
- 로그인 기록이 쿠키로 존재한다면, 프로필 페이지 이동
2. 로그인 페이지
- 이메일 및 비밀번호 필드, 로그인 버튼이 세로 정렬되어있음.
- 이메일 가입, 이메일 찾기, 비밀번호 버튼 존재
- 이메일 가입 버튼 클릭시 이용약관 페이지로 이동
- 로그인 버튼 클릭시 프로필 페이지 이동
- 테스트용 이메일: test@test.com, 테스트용 비밀번호: test1234
3. 이용약관 페이지
- 이용약관과 하단에 동의하기 버튼 존재
- 동의 버튼 클릭시 회원가입 페이지 이동
4. 회원가입 페이지
- 이름, 이메일, 비밀번호, 비밀번호인증, 전화번호 입력 필드 세로 정렬
- 모든 필드가 입력되면 가입 환영 페이지로 이동
5. 가입 환영 페이지
- '회원가입을 환영합니다' 문구가 중앙에 존재
- 3,2,1초 후에 로그인 페이지로 이동합니다. 구현
- 하단에 로그인 페이지 이동 버튼 존재
6. 프로필 페이지
- 상단에 사용자 이름, 회원정보 수정 버튼 존재
- 하단에 로그아웃 버튼 존재

## 상세 디자인 구현
1. 로딩 화면 구현 ✅
   - 스테이션 미선택 상태 ✅
     - 화면 중앙에 🐝 아이콘 3개를 가로로 나란히 배치
     - 왼쪽부터 순서대로 깜빡이는 애니메이션 효과 적용
     - 각 아이콘은 0.5초 간격으로 순차적으로 깜빡임
   - 스테이션 선택 상태 ✅
     - 🐝가 🍯을 들고 화면을 가로지르는 애니메이션
     - 부드러운 곡선 움직임으로 자연스러운 비행 경로 구현
     - 애니메이션 반복 주기는 3초로 설정

2. 결제 완료 화면 구현 ✅
   - 중앙 배치 요소 ✅
     - 🩷 아이콘과 ![alt text](image.png) 이미지를 수평으로 배치
     - 배치 순서: 🩷 - ![alt text](image.png) - 🩷
     - 모든 아이콘과 이미지는 동일한 크기로 설정 (50x50)
     - "결제가 완료되었습니다" 문구는 아이콘 아래 20px 간격으로 배치
     - 폰트는 Bold 처리, 크기는 18px로 설정
   - 하단 버튼 ✅
     - "홈으로 돌아가기" 버튼은 화면 하단에서 50px 위에 배치
     - 버튼 너비는 화면의 90%로 설정
     - 버튼 높이는 56px로 통일
     - 클릭시 즉시 홈 화면으로 이동

3. 테마 색상 업데이트 ✅
   - 포인트 색상을 짙은 노란색(#FFD700)으로 변경
   - 적용 대상:
     - 버튼 배경색
     - 선택된 아이템 하이라이트
     - 진행 상태 표시
     - 아이콘 색상
   - 관련 컴포넌트 스타일 일괄 적용


## 회원 관리 요구사항 진행 상황
1. 로그인 페이지 수정 ✅
   - 네비게이션 바 추가
   - 이메일 가입 버튼 클릭 시 이용약관 페이지로 이동

2. 회원가입 페이지 수정 ✅
   - 모든 필드가 입력되면 가입 환영 페이지로 이동

3. 가입 환영 페이지 수정 ✅
   - 3, 2, 1초 후에 로그인 페이지로 이동

4. 프로필 페이지 수정 ✅
   - 회원정보 수정 버튼 클릭 시 회원정보 수정 페이지로 이동

## 추가 요구사항
1. 스테이션 선택을 위한 페이지 구현 ✅
   - 스타벅스 앱의 '매장 설정 페이지' 참고 ✅
   - 홈화면의 '주변 스테이션' 누르면 해당 페이지로 이동 ✅
   - 대여 아이템 상세 페이지에서 '스테이션 설정' 누르면 해당 페이지로 이동 ✅
   - 스테이션이 설정되면 쿠키에 저장 ✅
2. 대여 아이템 상세 페이지 구현 ✅
   - 잔여수량 표시 ✅
   - 대여 시간 선택 기능 추가 ✅
   - 최하단에 버튼 ✅
      - 쿠키에 스테이션 정보가 존재하면: 스테이션 이름, 스테이션 변경 버튼 ✅
      - 쿠키에 스테이션 정보가 존재하지 않으면: 스테이션 선택 버튼 ✅
3. 위치 권한을 묻는 다이얼로그 ✅
   - 위치 권한을 허용하지 않으면 위치 권한을 허용하는 다이얼로그 출력 ✅