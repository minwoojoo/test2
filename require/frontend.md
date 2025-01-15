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


## 추가 요구사항
1. 네비게이션 기능 수정
- 하단 대여 버튼 클릭시 대여 아이템 페이지 구현
2. 대여 아이템 페이지 구현
- 상단에 카테고리
- 중단: 카테고리에 따른 아이템 리스트
- 최하단에 버튼
    - 홈에서 페이지 이동된 경우: 스테이션 선택
    - 지도에서 페이지 이동된 경우: 스테이션 이름, 스테이션 변경 버튼
- 카테고리 예시
    - 충전기: 노트북 고출력 충전기, 노트북 PD 충전기, C타입 충전기, 8핀 충전기
    - 케이블: HDMI 케이블, DP 케이블, C to C 케이블, C to A 케이블, A to C 케이블
    - 독: SD 카드 독(type A, C), USB 독(type A, C), 멀티 독(type A, C)
    - 보조배터리: 노트북용, 휴대폰용
    - 기타: 발표용 리모콘
3. 대여 아이템 상세 페이지 구현
- 상단에 아이템 이미지
- 중단에 아이템 이름, 가격, 설명
- 최하단에 버튼
    - 홈에서 페이지 이동된 경우: 스테이션 선택
    - 지도에서 페이지 이동된 경우: 결제 버튼

## 추가 요구사항 2
1. 홈 화면
- 현재 대여 중, 최근 대여 내역, 주변 스테이션 컴포넌트 명확히 구분
2. 대여 아이템 페이지
- '대여하기' 바에 '선택된 스테이션'이 가려짐
3. 대여 아이템 상세 페이지
- 대여 버튼 클릭시 대여 아이템 페이지로 이동
- 이미지 1:1 비율
4. @prd.md 참고하여 마이페이지 구현
- 하단 네비게이션 바 클릭시
    - 로그인 전: 로그인 페이지로 이동
        - 이메일 가입 버튼 존재: 클릭 시 이메일 가입 페이지로 이동
    - 로그인 후: 프로필 페이지로 이동

## 회원관리 구현
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