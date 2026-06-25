# Flutter 12주 실무 코드랩

**완전 입문자**부터 시작해 12주 만에 **Bloc · 클린 아키텍처 · Firebase · 온디바이스 AI**까지
도달하는 단계별 코드랩입니다. 각 주차는 **실제로 `flutter run`으로 빌드·실행되는 프로젝트**이며,
주차 폴더 안의 `README.md`가 그 주의 코드랩 가이드입니다.

> 환경 기준: Flutter 3.35.x / Dart 3.9.x · 대상 플랫폼 Android + iOS

---

## 학습 구조 (3-3-3-3)

앞 절반(1~6주)은 **개념을 작은 독립 예제**로 천천히 익히고,
뒤 절반(7~12주)은 그 개념들을 하나의 앱 **MindNote**(메모 + AI 요약)로 통합합니다.

| 주차 | 주제 | 형태 | 폴더 |
|---|---|---|---|
| 01 | Dart 기초 & 첫 Flutter 앱 | 독립 | [`week01_dart_basics`](week01_dart_basics) |
| 02 | 위젯 & 레이아웃 | 독립 | [`week02_widgets_layout`](week02_widgets_layout) |
| 03 | 입력 · 리스트 · 내비게이션 | 독립 | [`week03_input_list_nav`](week03_input_list_nav) |
| 04 | Bloc 입문 (Cubit → Bloc) | 독립 | [`week04_bloc_intro`](week04_bloc_intro) |
| 05 | MVVM & 클린 아키텍처 레이어 | 독립 | [`week05_clean_architecture`](week05_clean_architecture) |
| 06 | DI · Repository · 로컬 영속성 | 독립 | [`week06_di_repository_local`](week06_di_repository_local) |
| 07 | MindNote 시작 + Firebase 셋업 | 통합 | [`mindnote`](mindnote) · [docs/week07](mindnote/docs/week07.md) |
| 08 | 소셜 로그인 (구글·애플·카카오) | 통합 | [docs/week08](mindnote/docs/week08.md) |
| 09 | FCM 푸시 알림 | 통합 | [docs/week09](mindnote/docs/week09.md) |
| 10 | Crashlytics & 에러 처리 | 통합 | [docs/week10](mindnote/docs/week10.md) |
| 11 | 온디바이스 AI — Gemini Nano | 통합 | [docs/week11](mindnote/docs/week11.md) |
| 12 | 테스트 · CI/CD · 배포 개요 | 통합 | [docs/week12](mindnote/docs/week12.md) |

---

## 공통 문서

- [docs/00-getting-started.md](docs/00-getting-started.md) — Flutter 설치 · 환경 · 실행 공통 안내
- [docs/architecture.md](docs/architecture.md) — 클린 아키텍처 / MVVM / Bloc 개념 (7주차 이후 공유)
- [docs/firebase-setup.md](docs/firebase-setup.md) — Firebase · 카카오 · 애플 콘솔 설정 가이드

---

## 사용 방법

```bash
# 원하는 주차로 이동해서 실행
cd week01_dart_basics
flutter pub get
flutter run            # 연결된 기기/시뮬레이터에서 실행

# 7~12주는 모두 같은 앱(mindnote) 하나를 누적 발전시킵니다
cd mindnote
flutter pub get
flutter run
```

---

## 📦 저장소 구성 (모노레포 + git submodule)

이 저장소는 **루트 저장소**이고, 각 코드랩은 **독립된 git 저장소**입니다.
원격(GitHub)에 올린 뒤 루트에서 git submodule로 묶습니다.

```
flutter_codelab/            ← 루트 저장소 (이 저장소)
├── README.md / docs/       ← 공통 문서 (루트에서 직접 관리)
├── scripts/setup-submodules.sh
├── week01_dart_basics/     ┐
├── ...                     ├─ 각각 독립 저장소 → submodule로 연결
└── mindnote/               ┘
```

### 원격에 올리고 submodule로 연결하기

각 코드랩 폴더는 이미 `git init` + 첫 커밋이 되어 있습니다. 원격 저장소만
만들면 됩니다(폴더명 == 저장소명으로 가정).

```bash
# 1) 각 코드랩 원격 저장소 생성 + 푸시 (gh CLI 예시)
for d in week01_dart_basics week02_widgets_layout week03_input_list_nav \
         week04_bloc_intro week05_clean_architecture week06_di_repository_local mindnote; do
  gh repo create "$GITHUB_USER/$d" --public --source "$d" --remote origin --push
done

# 2) 루트에서 submodule로 한 번에 연결
GITHUB_USER=your-id ./scripts/setup-submodules.sh
```

`setup-submodules.sh`가 각 폴더를 원격에 push하고, 루트의 `.gitmodules`에
submodule로 등록합니다. (SSH를 쓰려면 `USE_SSH=1`)

### 클론하는 사람은?

```bash
git clone --recurse-submodules <루트저장소 URL>
# 이미 클론했다면:
git submodule update --init --recursive
```

---

각 주차 README는 다음 흐름을 따릅니다:

> 🎯 **목표** → 🧰 **사전 준비** → 🪜 **단계별 구현** → ▶️ **실행** → 🚀 **도전 과제**

가이드 곳곳에 ✅ **체크포인트**(여기까지 됐는지 확인)와 ⚠️ **흔한 오류**가 있습니다.

---

## ⚠️ Firebase / 소셜 로그인 키에 대하여

7주차 이후 코드는 동작하지만, **Firebase·카카오·애플의 실제 키는 포함되어 있지 않습니다.**
저장소에는 더미(placeholder) 설정이 들어 있고, 다음 위치에 `// TODO: replace with your own`
주석으로 표시돼 있습니다.

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

키가 없어도 앱은 **크래시 없이 "Firebase 미설정" 안내 화면**을 띄우도록 만들어져 있어,
설정 전에도 구조를 둘러볼 수 있습니다. 실제 로그인/푸시를 테스트하려면
[docs/firebase-setup.md](docs/firebase-setup.md)를 따라 본인 키로 교체하세요.

---

## 진도 추천

- **1주차에 1폴더**가 기본 페이스입니다.
- 4~5주(Bloc / 클린 아키텍처)에서 처음으로 "패턴"이 등장합니다. 이해가 더디면
  [docs/architecture.md](docs/architecture.md)를 먼저 가볍게 읽고 오세요.
- 7주차부터는 새 프로젝트를 만들지 않고 `mindnote` 하나에 매주 기능을 더합니다.
  코드 안의 `// [WEEK 08]` 같은 마커로 "몇 주차에 추가된 코드"인지 표시돼 있습니다.
