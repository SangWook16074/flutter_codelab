# 00. 시작하기 — 환경 준비와 실행

이 코드랩을 따라오기 위한 **공통 준비**입니다. 한 번만 해두면 12주 내내 씁니다.

---

## 1. Flutter 설치 확인

이미 설치돼 있다면 버전부터 확인하세요.

```bash
flutter --version
# Flutter 3.35.x / Dart 3.9.x 정도면 충분합니다
```

설치가 안 돼 있다면 공식 가이드를 따르세요: <https://docs.flutter.dev/get-started/install>

설치 후 진단:

```bash
flutter doctor
```

`[✓]`가 가능한 한 많이 떠야 합니다. 우리는 **Android + iOS**를 다루므로
최소한 아래가 ✓여야 합니다.

- ✅ Flutter
- ✅ Android toolchain (Android Studio + SDK)
- ✅ Xcode (Mac에서 iOS 빌드 시)

> ⚠️ **흔한 오류** — `Android license status unknown`이 뜨면
> `flutter doctor --android-licenses`를 실행하고 모두 `y`로 동의하세요.

---

## 2. 에디터

- **VS Code**: `Flutter` 확장 설치 (Dart 확장은 자동 포함)
- **Android Studio**: `Flutter` 플러그인 설치

둘 다 자동완성·핫 리로드·디버깅을 지원합니다. 입문자는 VS Code를 추천합니다.

---

## 3. 실행할 기기 준비

다음 중 하나면 됩니다.

| 방법 | 명령/방법 |
|---|---|
| Android 에뮬레이터 | Android Studio → Device Manager → 가상 기기 생성 |
| iOS 시뮬레이터 (Mac) | `open -a Simulator` |
| 실제 Android 기기 | USB 연결 + 개발자 모드 + USB 디버깅 |
| 실제 iPhone | USB 연결 + 개발자 모드 (Xcode 서명 필요) |

연결된 기기 확인:

```bash
flutter devices
```

---

## 4. 주차 프로젝트 실행하는 법

각 주차 폴더는 독립적인 Flutter 프로젝트입니다.

```bash
cd week01_dart_basics     # 원하는 주차 폴더
flutter pub get           # 의존성 내려받기 (처음 1회 + pubspec 바뀔 때마다)
flutter run               # 기기가 여러 개면 골라야 합니다
```

기기를 직접 지정하려면:

```bash
flutter run -d <device_id>   # flutter devices 에서 본 id
```

실행 중 단축키:

- `r` — **핫 리로드** (코드 바꾸고 즉시 반영, 상태 유지)
- `R` — **핫 리스타트** (상태 초기화하고 다시 시작)
- `q` — 종료

> ✅ **체크포인트** — `flutter run` 후 기본 화면이 뜨고, 코드를 조금 바꾸고
> `r`을 눌렀을 때 화면이 바뀌면 환경 준비 완료입니다.

---

## 5. 코드 점검 명령 (자주 씁니다)

```bash
flutter analyze     # 정적 분석 (경고/에러 잡기). 0 경고가 목표
flutter test        # 테스트 실행
dart format .       # 코드 자동 정렬
```

> ⚠️ **흔한 오류** — `flutter run`이 갑자기 깨지면 `flutter clean` 후
> `flutter pub get`을 다시 해보세요. 캐시 문제의 90%가 해결됩니다.
