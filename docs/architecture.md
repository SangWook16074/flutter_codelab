# 아키텍처 — MVVM · 클린 아키텍처 · Bloc

7주차 이후 `mindnote` 앱이 따르는 구조를 한곳에 정리합니다.
4~6주에서 작은 예제로 먼저 배우고, 여기서 "왜 이렇게 나누는가"를 잡아가세요.

---

## 왜 레이어를 나누나?

작은 앱은 한 파일에 다 써도 돕니다. 하지만 화면·로직·서버 코드가 뒤섞이면:

- 테스트가 어렵다 (UI를 띄워야만 로직을 검증할 수 있음)
- 변경이 무섭다 (한 줄 고치면 어디가 깨질지 모름)
- 협업이 꼬인다 (같은 파일을 여럿이 건드림)

그래서 **역할별로 층(layer)을 나눕니다.** 핵심 규칙 하나만 기억하세요:

> **의존성은 안쪽(도메인)을 향한다.**
> UI는 도메인을 알아도 되지만, 도메인은 UI나 서버를 몰라야 한다.

---

## 3개의 레이어

```
┌─────────────────────────────────────────────┐
│ presentation  화면 + Bloc (상태관리)          │  ← Flutter 위젯, UI 상태
│   ↓ 호출                                      │
│ domain        Entity · UseCase · Repository(추상)│  ← 순수 Dart, 비즈니스 규칙
│   ↑ 구현                                      │
│ data          RepositoryImpl · DataSource · Model│  ← Firebase/로컬/HTTP
└─────────────────────────────────────────────┘
```

| 레이어 | 들어가는 것 | 의존 방향 |
|---|---|---|
| **presentation** | Widget, Page, **Bloc/Cubit**, UI State | domain을 호출 |
| **domain** | **Entity**, **UseCase**, **Repository 인터페이스(추상)** | 아무것도 모름 (순수 Dart) |
| **data** | **RepositoryImpl**, DataSource(Firebase/Hive/HTTP), Model(DTO) | domain을 구현 |

**핵심 트릭**: 도메인은 `abstract class NoteRepository`만 정의하고,
data 레이어가 그것을 `class NoteRepositoryImpl implements NoteRepository`로 구현합니다.
그래서 도메인은 "저장소가 있다"는 사실만 알 뿐, **그게 Firebase인지 Hive인지 모릅니다.**
나중에 Firebase → 다른 DB로 갈아끼워도 도메인·UI는 안 바뀝니다.

---

## MVVM과 어떻게 연결되나?

MVVM(Model–View–ViewModel)과 클린 아키텍처는 충돌하는 개념이 아닙니다.
Flutter + Bloc에서는 보통 이렇게 매핑합니다.

| MVVM | 이 코드랩에서 |
|---|---|
| **View** | Widget / Page (presentation) |
| **ViewModel** | **Bloc / Cubit** (presentation) — View와 도메인 사이 중개 |
| **Model** | Entity(domain) + Model(data) |

즉 **Bloc이 ViewModel 역할**을 합니다. View는 Bloc의 State를 그리고,
사용자 입력을 Event로 Bloc에 보냅니다. Bloc은 UseCase를 호출해 일을 처리합니다.

---

## Bloc 한눈에

```
[사용자가 버튼 탭]
      │  add(Event)
      ▼
┌──────────┐   UseCase 호출   ┌──────────┐
│   Bloc   │ ───────────────▶ │  domain  │
│ (ViewModel)│ ◀────────────── │  /data   │
└──────────┘   결과 데이터       └──────────┘
      │  emit(State)
      ▼
[화면이 새 State로 다시 그려짐]
```

- **Event**: "무슨 일이 일어났는가" (예: `LoadNotes`, `AddNote`)
- **State**: "지금 화면이 어떤 상태인가" (예: `NotesLoading`, `NotesLoaded`, `NotesError`)
- **Bloc**: Event를 받아 → 일을 처리하고 → 새 State를 `emit`

> **Cubit**은 Bloc의 단순 버전입니다. Event 없이 메서드를 직접 호출(`increment()`)하고
> State만 emit합니다. 4주차에서 Cubit → Bloc 순서로 배웁니다.

---

## mindnote 폴더 구조 (7주차~)

```
lib/
├── main.dart
├── core/                 # 앱 전역 공통
│   ├── di/               # get_it 의존성 등록
│   ├── error/            # Failure 타입, 전역 에러 핸들러
│   ├── router/           # go_router 라우팅 + 인증 가드
│   ├── theme/            # ThemeData
│   └── firebase/         # Firebase 초기화 + 미설정 가드
└── features/
    ├── auth/
    │   ├── data/         # AuthRepositoryImpl, *RemoteDataSource
    │   ├── domain/       # User(Entity), AuthRepository(추상), SignIn(UseCase)
    │   └── presentation/ # AuthBloc, LoginPage
    ├── notes/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── ai_summary/
        ├── data/
        ├── domain/
        └── presentation/
```

**feature-first** 구조입니다. 레이어로 먼저 나누지 않고 **기능(feature)으로 먼저 나눈 뒤**,
각 기능 안에서 data/domain/presentation 3층을 둡니다. 기능 단위로 코드가 모여 있어
"메모 기능 어디 있지?"를 찾기 쉽습니다.

> ✅ **체크포인트** — 새 코드를 짤 때 "이건 어느 레이어에 들어가야 하지?"를 스스로 물어보세요.
> 서버/DB 이야기면 data, "규칙"이면 domain, 화면/상태면 presentation입니다.
