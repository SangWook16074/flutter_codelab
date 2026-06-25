# Firebase · 카카오 · 애플 설정 가이드

7주차 이후 `mindnote` 앱은 Firebase와 소셜 로그인을 사용합니다.
**저장소의 설정 파일은 모두 더미(placeholder)** 이므로, 실제 로그인/푸시를
테스트하려면 본인 콘솔 값으로 교체해야 합니다.

> 키가 없어도 앱은 크래시 없이 **"Firebase 미설정" 안내 화면**을 띄웁니다
> (`lib/core/firebase/firebase_guard.dart` 참고). 구조만 둘러볼 거면 설정은 건너뛰어도 됩니다.

---

## 1. FlutterFire CLI로 Firebase 연결

가장 쉬운 길은 공식 CLI입니다.

```bash
# 1) Firebase CLI 설치 (Node 필요) 후 로그인
npm install -g firebase-tools
firebase login

# 2) FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# 3) mindnote 폴더에서 실행 — Firebase 프로젝트를 고르면 자동 생성됨
cd mindnote
flutterfire configure
```

이 명령이 자동으로 만들어 주는(=placeholder를 덮어쓰는) 파일:

| 파일 | 역할 |
|---|---|
| `lib/firebase_options.dart` | 플랫폼별 Firebase 옵션 |
| `android/app/google-services.json` | Android 설정 |
| `ios/Runner/GoogleService-Info.plist` | iOS 설정 |

> ⚠️ 이 파일들에는 프로젝트 식별자가 들어갑니다. 공개 저장소라면 `.gitignore`에
> 추가하는 걸 고려하세요. (API 키 자체는 비밀이 아니지만, 규칙 설정으로 보호해야 합니다.)

---

## 2. 활성화할 Firebase 제품

[Firebase Console](https://console.firebase.google.com)에서 다음을 켭니다.

- **Authentication** — Google, Apple 공급자 사용 설정
- **Cloud Firestore** — 메모 저장 (7주차)
- **Cloud Messaging (FCM)** — 푸시 (9주차)
- **Crashlytics** — 크래시 리포팅 (10주차)

---

## 3. 구글 로그인

`flutterfire configure`로 대부분 끝나지만 추가로:

- **Android**: 디버그/릴리즈 **SHA-1, SHA-256** 지문을 Firebase 프로젝트에 등록
  ```bash
  cd android && ./gradlew signingReport   # SHA 지문 확인
  ```
- **iOS**: `GoogleService-Info.plist`의 **REVERSED_CLIENT_ID**를
  `ios/Runner/Info.plist`의 URL Scheme에 추가 (8주차 가이드에 코드 위치 표시)

---

## 4. 애플 로그인

- [Apple Developer](https://developer.apple.com) → Identifiers → App ID에서
  **Sign in with Apple** capability 활성화
- Xcode → Runner → Signing & Capabilities → **Sign in with Apple** 추가
- Firebase Auth → Apple 공급자 사용 설정 (Service ID, 키 등록은 콘솔 안내를 따름)

> Android에서 애플 로그인을 쓰려면 웹 인증 흐름(Service ID + Return URL)이 추가로 필요합니다.
> 8주차 가이드에서 `sign_in_with_apple` 패키지 설정으로 다룹니다.

---

## 5. 카카오 로그인

카카오는 Firebase가 아니라 **카카오 자체 SDK + Firebase Custom Token** 조합입니다.

1. [Kakao Developers](https://developers.kakao.com) → 애플리케이션 추가
2. **네이티브 앱 키** 발급 → `lib/core/firebase/secrets.dart`의 placeholder 교체
   (또는 `--dart-define=KAKAO_NATIVE_APP_KEY=...`)
3. 플랫폼 등록:
   - **Android**: 키 해시 등록
   - **iOS**: Bundle ID 등록, `Info.plist`에 URL Scheme (`kakao{네이티브앱키}`) 추가
4. (선택) 카카오 로그인 결과를 Firebase 사용자와 연동하려면 **Custom Token**을 발급하는
   백엔드(Cloud Functions 등)가 필요합니다. 8주차 가이드는 클라이언트 흐름까지 다루고,
   Custom Token 연동은 "도전 과제"로 안내합니다.

---

## 6. placeholder 위치 한눈에

코드에서 아래 마커를 검색하면 교체할 곳을 모두 찾을 수 있습니다.

```bash
cd mindnote
grep -rn "TODO: replace with your own" .
```

| 위치 | 교체 내용 |
|---|---|
| `lib/firebase_options.dart` | FlutterFire 자동 생성 값 |
| `android/app/google-services.json` | Android Firebase 설정 |
| `ios/Runner/GoogleService-Info.plist` | iOS Firebase 설정 |
| `lib/core/firebase/secrets.dart` | 카카오 네이티브 앱 키 등 |

> ✅ **체크포인트** — 교체 후 `flutter run`을 다시 했을 때 "Firebase 미설정" 안내 화면이
> 사라지고 실제 로그인 화면이 뜨면 설정 성공입니다.
