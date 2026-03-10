# Qizlar Academy Mobile — Project reference

This document defines structure and conventions for the qizlar_academy_mobile app. All new and refactored code must follow it. All third-party packages must come from **packages/qizlar_academy_kit/pubspec.yaml**; see the "Kit packages" section below.

---

## 1. Root structure

- **lib/main.dart** — Widget binding init, `setupLocator()`, then `runApp(App())`.
- **lib/app.dart** — Root widget (MaterialApp.router or MaterialApp), theme, router.
- **lib/config/** — Router, DI, constants, theme, flavor, settings, l10n.
- **lib/core/** — Shared components, assets (generated).
- **lib/feature/** — One folder per feature; each has domain, data, presentation.

---

## 2. config/

- **router/app_routes.dart** — GoRouter, routes; `part 'path_routes.dart';`.
- **router/path_routes.dart** — `part of 'app_routes.dart';`; path constants (e.g. `Routes.splash`, `Routes.home`).
- **di/setup_locator.dart** — GetIt (`getIt`); register singletons (e.g. SettingsDataSource, AppOptionsService, GoRouter).
- **constants/** — colors, text_styles, apis, app_keys, app_radius, gradients, shadows, icons, theme (app_theme, app_options, theme_extension), user_type.
- **flavor/** — env_config, app_remote_config.
- **settings/** — settings_data_source (implementation can use SharedPreferences from the kit).
- **l10n/** — Localization setup.

---

## 3. core/

- **components/** — Shared widgets (e.g. app_components barrel).
- **assets/** — Generated (e.g. assets.gen.dart / UiKitAssets) via flutter_gen; config in root pubspec under flutter_gen.

---

## 4. Feature module structure

Each feature: **feature/feature_name/**

- **domain/model/** — Entities/models.
- **domain/repository/** — Abstract `XxxRepository`.
- **data/repository/** — `XxxRepositoryImpl extends XxxRepository`.
- **presentation/screens/** — `*_screen.dart` (or `*_page.dart`); optionally `*_mixin.dart` in the same folder.
- **presentation/bloc/** — `*_bloc.dart`, `*_event.dart`, `*_state.dart` (part files).
- **presentation/components/** — Widgets used only in this feature.

Use **screens** or **page** consistently (this project uses `screens/` and `*_screen.dart` in existing code).

---

## 5. Page / View / Mixin pattern

- **Option A:** `XxxScreen` (Stateless) provides BlocProvider and returns `XxxView` (Stateful). State uses `XxxMixin on State<XxxView>`.
- **Option B:** `XxxScreen` (Stateful). State uses `XxxMixin on State<XxxScreen>`.

Mixin file: `*_mixin.dart` next to the screen. In the mixin: navigation (`context.go`, `context.pop`), bloc add/listener methods, lifecycle (initState, dispose), controllers, dialogs/snackbars. Build method stays in the screen/widget file.

Listener naming: `xxxBlocListener(BuildContext context, XxxState state)` or `blocListener` for a single bloc.

### 5.1 Mixin va componentlarga ajratish qonuniyatlari

- **Komponentga ajratish:** Ekrandagi mantiqiy UI bloklari (masalan markaziy logo, pastki hamkorlar, forma bloki) alohida **StatelessWidget** sifatida `feature/.../presentation/components/` ichida yoziladi. Har bir komponent o‘z faylida (masalan `splash_center_content.dart`, `splash_bottom_partners.dart`). Maqsad: qayta ishlatish, test qilish osonligi, bitta javobgarlik (Single Responsibility).
- **Mixin’ga ko‘chirish:** Ekrandagi `_buildXxx(BuildContext)` kabi UI qismlarini qaytaruvchi metodlar **mixin**ga ko‘chiriladi. Mixin `buildCenterContent(BuildContext)`, `buildBottomPartners(BuildContext)` kabi metodlar orqali faqat shu feature komponentlarini qaytaradi (`return const XxxComponent();`). Ekran o‘zi faqat layout (Column, Stack, …) va animatsiya/lifecycle bilan shug‘ullanadi; kontent mixin orqali olinadi.
- **Tsiklik importdan qochish:** Mixin fayli ekran faylini import qilmasin. Bunun uchun mixin **generic** bo‘ladi: `mixin XxxScreenMixin<T extends StatefulWidget> on State<T>`. Ekranda: `class _XxxScreenState extends State<XxxScreen> with XxxScreenMixin<XxxScreen>`.
- **Joylashuv:** Mixin — `presentation/screens/` da, ekran yonida (`*_screen_mixin.dart`). Komponentlar — `presentation/components/` da, aniq nom bilan (`*_center_content.dart`, `*_bottom_partners.dart` va h.k.).
- **Import:** Komponentlar va mixin `app_components` (yoki config) va kerak bo‘lsa kit import qiladi; ekran mixin va router’ni import qiladi, komponentlarni to‘g‘ridan-to‘g‘ri import qilmaydi (faqat mixin orqali ishlatadi).

---

## 6. Components

- **Core:** `core/components/` — shared across features; StatelessWidget; use config (colors, text_styles, theme).
- **Feature:** `feature/.../presentation/components/` — only that feature; clear props; use config for styling.
- **Ajratish:** Ekran build ichidagi yirik UI bloklarni alohida widget qilib `presentation/components/` ga chiqaring; ekranda ularni mixin metodlari orqali chaqiring (5.1 ga qarang).

---

## 7. Bloc structure

- **Files:** `xxx_bloc.dart` with `part 'xxx_event.dart';` and `part 'xxx_state.dart';`. Event/state files: `part of 'xxx_bloc.dart';`.
- **Event:** `sealed class XxxEvent extends Equatable`; per-event classes; `props` override; const constructors.
- **State:** `class XxxState extends Equatable`; enum for status (`initial`, `loading`, `failure`, `successXxx`); `copyWith`; `props` include status, data, message.
- **Bloc class:** Repository (or deps) injected in constructor; `on<XxxEvent>(_handlerName)`; private handlers; flow: emit loading → repository → emit success/failure.

Use **equatable** and **bloc**/ **flutter_bloc** from the kit (import via kit when re-exported).

---

## 8. Router and DI

- **Router:** Paths and helpers in `path_routes.dart`; GoRouter in `app_routes.dart`; BlocProvider in builder when needed.
- **DI:** All registration in `config/di/setup_locator.dart`. Use `getIt` (GetIt from kit). In screens/routes, get services via `getIt<X>()` or BlocProvider(create: (context) => getIt<XxxBloc>()).

---

## 9. Kit packages (mandatory)

All app dependencies must be declared in **packages/qizlar_academy_kit/pubspec.yaml**. The root app **pubspec.yaml** must not add new third-party packages (only `qizlar_academy_kit` path dependency and SDK).

### Kit dependency list (use only these; add new ones to the kit)

- **UI / icons:** cupertino_icons, lucide_icons_flutter, flutter_pannable_rating_bar  
- **Fonts:** google_fonts  
- **Routing:** go_router  
- **Logging:** logger  
- **Vibration:** gaimon  
- **Firebase:** firebase_core, firebase_remote_config, firebase_crashlytics  
- **State / DI:** bloc, flutter_bloc, get_it, equatable, intl  
- **Code gen:** freezed_annotation, json_annotation (dev: freezed, json_serializable, build_runner)  
- **HTTP:** dio, http_parser, dartz  
- **Connectivity:** connectivity_plus, internet_connection_checker_plus  
- **Maps / URL:** map_launcher, url_launcher  
- **Sharing / permissions:** share_plus, permission_handler  
- **Device / locale:** devicelocale  
- **Storage / cache:** shared_preferences, flutter_cache_manager  
- **Forms / UI:** pinput, sms_autofill, pull_to_refresh  
- **UI / assets:** flutter_svg, cached_network_image, flutter_screenutil, flutter_html, liquid_glass_renderer  
- **Device / security:** screenshot, screen_protector  
- **Other:** in_app_review, flutter_staggered_animations, flutter_local_notifications, fluttertoast  

### Import convention

- Prefer **`import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';`** for: Flutter, go_router, flutter_bloc, get_it, equatable, firebase_*, shared_preferences, cupertino_icons (or whatever the kit barrel file exports). Use one kit import instead of many package imports when the kit re-exports them.
- For other packages that are in the kit but not re-exported: add an export in **packages/qizlar_academy_kit/lib/qizlar_academy_kit.dart** and then import the kit in the app, or import the package directly (the dependency must still be only in the kit’s pubspec, not the root).

---

## 10. Summary

- **Structure:** config, core, feature; each feature = domain + data + presentation (screens, bloc, components).
- **Packages:** Only from **packages/qizlar_academy_kit/pubspec.yaml**; root app does not add new third-party deps.
- **Imports:** Prefer `package:qizlar_academy_kit/qizlar_academy_kit.dart` for re-exported packages.
- **Screens:** Page/View/Mixin; mixin for logic and navigation; Bloc with part event/state; components from config/core or feature.
