# Qizlar Academy Mobile — Project instructions

This file is read by Cursor in every conversation. Follow these rules when editing qizlar_academy_mobile. For full details see **.cursor/skills/qizlar-academy-project/reference.md**.

---

## 1. Packages (mandatory)

- **All third-party packages** must be declared in **packages/qizlar_academy_kit/pubspec.yaml**.
- **Root pubspec.yaml** must NOT add new third-party dependencies. Only: `flutter`, `flutter_localizations`, `qizlar_academy_kit` (path), and any allowed dev tooling.
- New capability → add dependency to the **kit’s pubspec**, use it in the app transitively.
- In lib code, **prefer** `import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';` for re-exported packages (Flutter, go_router, flutter_bloc, get_it, equatable, firebase_*, shared_preferences, etc.). For others in the kit, add export in the kit barrel or import the package; dependency must still live only in the kit.

---

## 2. Root structure

- **lib/main.dart** — Widget binding init, `setupLocator()`, then `runApp(App())`.
- **lib/app.dart** — Root widget (MaterialApp.router), theme, router.
- **lib/config/** — Router, DI, constants, **enum/** (shared enums), theme, flavor, settings, l10n.
- **lib/config/logs/** — markaziy logging (`AppLogger`); barcha loglar shu qatlam orqali yoziladi.
- **lib/core/** — Shared components, generated assets.
- **lib/feature/** — One folder per feature; each has domain, data, presentation.

---

## 3. Feature module structure

Per feature: **feature/feature_name/**

- **domain/model/** — Entities/models.
- **domain/repository/** — Abstract `XxxRepository`.
- **data/repository/** — `XxxRepositoryImpl extends XxxRepository`.
- **presentation/screens/** — `*_screen.dart`, optionally `*_mixin.dart` beside it.
- **presentation/bloc/** — `*_bloc.dart` with `part 'xxx_event.dart';` and `part 'xxx_state.dart';`.
- **presentation/components/** — Widgets used only in this feature.

This project uses **screens/** and `*_screen.dart` consistently.

**Nested sub-screen (ichki ekran):** When a feature has a dedicated sub-flow screen (e.g. profile list → edit profile), colocate its screen, mixin, bloc (part files), and screen-only components under **`presentation/screens/<slug>/`** with `bloc/` and `components/` subfolders. Shared feature blocs stay in `presentation/bloc/`. See **.cursor/skills/qizlar-academy-project/reference.md** section **4.1**.

---

## 4. Page / View / Mixin pattern

- **Option A:** `XxxScreen` (Stateless) provides BlocProvider and returns `XxxView` (Stateful). State uses `XxxMixin on State<XxxView>`.
- **Option B:** `XxxScreen` (Stateful). State uses `XxxMixin on State<XxxScreen>`.

**Mixin** (`*_mixin.dart` next to screen): navigation (`context.go`, `context.pop`), bloc add/listener, lifecycle (initState, dispose), controllers, dialogs/snackbars. **Build method stays in the screen/widget file.**

Listener naming: `xxxBlocListener(BuildContext context, XxxState state)` or `blocListener` for a single bloc.

### 4.1 Mixin va componentlarga ajratish

- **Komponent:** Logical UI blocks (e.g. center logo, bottom partners) as separate **StatelessWidget** in `feature/.../presentation/components/`, one file per component (e.g. `splash_center_content.dart`, `splash_bottom_partners.dart`).
- **Mixin:** Move `_buildXxx(BuildContext)`-style methods into the mixin. Mixin exposes e.g. `buildCenterContent(BuildContext)`, `buildBottomPartners(BuildContext)` that return `const XxxComponent();`. Screen handles layout (Column, Stack) and animation/lifecycle; content comes from mixin.
- **No circular imports:** Mixin must not import the screen. Use **generic mixin:** `mixin XxxScreenMixin<T extends StatefulWidget> on State<T>`. Screen: `class _XxxScreenState extends State<XxxScreen> with XxxScreenMixin<XxxScreen>`.
- **Placement:** Mixin in `presentation/screens/` or `presentation/screens/<slug>/` (`*_screen_mixin.dart`). Components in `presentation/components/` or, for a nested screen only, in `presentation/screens/<slug>/components/` (see reference 4.1).
- **Imports:** Components and mixin import app_components/config and kit as needed. Screen imports mixin and router; does not import components directly (only via mixin).

---

## 5. Bloc structure

- **Files:** `xxx_bloc.dart` with `part 'xxx_event.dart';` and `part 'xxx_state.dart';`. Event/state: `part of 'xxx_bloc.dart';`.
- **Event:** `sealed class XxxEvent extends Equatable`; per-event classes; `props` override; const constructors.
- **State:** `class XxxState extends Equatable`; status enum (`initial`, `loading`, `failure`, `successXxx`); `copyWith`; `props` include status, data, message.
- **Bloc:** Repository/deps in constructor; `on<XxxEvent>(_handlerName)`; private handlers; emit loading → repository → emit success/failure.

Use equatable and bloc/flutter_bloc from the kit (import via kit when re-exported).

---

## 6. Router and DI

- **Router:** Paths in `config/router/path_routes.dart` (part of app_routes); GoRouter in `config/router/app_routes.dart`; BlocProvider in route builder when needed.
- **DI:** All registration in `config/di/setup_locator.dart`. Use `getIt` (GetIt from kit). In screens/routes: `getIt<X>()` or `BlocProvider(create: (context) => getIt<XxxBloc>())`.
- **Logging:** `logger` paketidan foydalaning, lekin loglarni faqat `lib/config/logs/app_logger.dart` dagi `AppLogger` orqali yozing. Feature/screen/bloc ichida alohida `Logger()` ochmang.

---

## 7. Components

- **Core:** `core/components/` — shared; StatelessWidget; use config (colors, text_styles, theme).
- **Feature:** `feature/.../presentation/components/` — only that feature; clear props; config for styling.
- Split large UI blocks from screen build into widgets in `presentation/components/`; call them via mixin methods (§4.1).

---

## 8. Store release builds (obfuscation)

### Versiya qoidalari
- `pubspec.yaml`: `version: x.y.z+build` — **store uchun rutin yuklovda faqat `build` (+ dan keyin) ni oshiring**. `x.y.z` (1.7.2, 1.7.3, …) ni faqat yangi foydalanuvchi versiyasi e’lon qilinishi kerak bo‘lganda o‘zgartiring; har safar ikkisini birdan ko‘paytirmang.
- iOS: `ios/Runner.xcodeproj/project.pbxproj` — Runner target: `MARKETING_VERSION` ↔ `x.y.z`, `CURRENT_PROJECT_VERSION` ↔ `build`.
- **Keyingi release reja (baseline):** keyingi build **1.7.3+46** (yoki hozirgi `x.y.z+` dan keyin faqat +1) — foydalanuvchi aytmaguncha marketing qatorni o‘zgartirmasdan.

Play Console va App Store uchun **release** artefaktlarni Dart **obfuscation** (`--obfuscate` + `--split-debug-info`) bilan yig‘ing — `uma_mobile` kabi loyihalarda shu yondashuv qo‘llaniladi. Android tomonda release **R8** (`android/app/build.gradle.kts`: `isMinifyEnabled`, `isShrinkResources`, `proguard-rules.pro`) alohida yoqilgan.

Loyiha ildizidan:

```bash
flutter pub get
flutter build appbundle --flavor prod --obfuscate --split-debug-info=build/debug-info
flutter build ipa --export-method app-store --obfuscate --split-debug-info=build/debug-info
```

- **AAB (prod):** `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- **iOS:** archive `build/ios/archive/Runner.xcarchive`, IPA `build/ios/ipa/`

**split-debug-info:** `build/debug-info/` papkasini store paketlariga qo‘shmang; crash/stack trace dekodlash uchun saqlang. Ikon tree-shaking bilan bog‘liq muammo bo‘lsa, build ga ixtiyoriy `--no-tree-shake-icons` qo‘shiladi.

---

Do not deviate from this or from **.cursor/skills/qizlar-academy-project/reference.md** when adding or refactoring code.
