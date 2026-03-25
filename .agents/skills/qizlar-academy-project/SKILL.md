---
name: qizlar-academy-project
description: Project rules and architectural guidelines for Qizlar Academy Mobile. Covers kit packages, Flutter clean architecture (config/core/feature), Page/View/Mixin pattern, Components separation, exception screens, and logging.
---

# Qizlar Academy — Project Skill

This skill provides architectural guidelines and rules for the `qizlar_academy_mobile` project. By adhering to these rules, you maintain a scalable, clean, and consistent codebase.

## 1. Kit Packages (Mandatory)
- **Do not add new dependencies to the root `pubspec.yaml`**. 
- All third-party packages must be defined in `packages/qizlar_academy_kit/pubspec.yaml`.
- In app code, prefer importing from `package:qizlar_academy_kit/qizlar_academy_kit.dart`.
- Root `pubspec.yaml` should only contain `flutter`, `flutter_localizations` (SDK), and the `qizlar_academy_kit` path dependency.

## 2. Architecture & File Structure
- **lib/main.dart**: Widget binding init, `setupLocator()`, then `runApp(App())`.
- **lib/config/**: Router (`app_routes.dart`, `path_routes.dart`), DI (`setup_locator.dart`), Enums (`enum/`), Theme, Constants, Logs (`logs/app_logger.dart`), and localization.
- **lib/core/**: Shared `components/` and generated `assets/` (via `flutter_gen`).
- **lib/feature/<feature_name>/**: 
  - `domain/`: `model/` (entities), `repository/` (abstract classes).
  - `data/`: `repository/` (implementations).
  - `presentation/`: `screens/` (or `page/`), `bloc/`, `components/`.

## 3. Page / View / Mixin Pattern
- Screens are located in `presentation/screens/`. Use `*_screen.dart`.
- **Mixin**: `*_mixin.dart` contains logic such as navigation (`context.go`, `context.pop`), bloc listener setup, lifecycle hooks (`initState`, `dispose`), controllers, and dialogs.
- **UI Logic**: The `build` method and UI layout stay in the screen widget. `_buildXxx(BuildContext)` methods that construct granular UI pieces should be placed in the mixin and return components.
- **Complex UI**: For large screens, separate UI sections into distinct `StatelessWidget`s in `presentation/components/` (e.g. `splash_center_content.dart`). 

## 4. Components & Skeleton Loaders
- **Loading State**: Avoid `CircularProgressIndicator`. Instead, use skeleton loaders via `skeletonizer`. For full pages, use `PageLoadingSkeleton`. For localized elements, make a custom skeleton in `presentation/components/`.
- **Exceptions & Errors**: For fail states with a retry button, use `TgsFailureContent` located in `feature/exception_screens/presentation/components/tgs_failure_content.dart`.

## 5. Global Toasts
- Do not build ad-hoc SnackBars or local Toasts. Use `AppToast` from `core/presentation/components/app_toast.dart`.
- Supported types: `success`, `error`, `warning`, `info`. Every toast contains a `.tgs` animation natively.

## 6. Bloc & State Management
- `xxx_bloc.dart` utilizes `part 'xxx_event.dart';` and `part 'xxx_state.dart';`.
- **Events**: `sealed class XxxEvent extends Equatable`. Const constructors, override `props`.
- **States**: `class XxxState extends Equatable`. Include an enum for status (`initial`, `loading`, `failure`, `success`). Add a `copyWith` method.
- **Bloc Flow**: `emit loading` -> call repository -> `emit success/failure`. Repositories should be injected into the Bloc via the constructor.

## 7. Routing & Dependency Injection
- **Routing**: `go_router` logic is in `config/router/app_routes.dart`. Use path constants in `path_routes.dart`.
- **DI**: Register singletons and factories in `config/di/setup_locator.dart` referencing `getIt`. Get references using `getIt<X>()`.

## 8. Logging
- **All app logs** must go through `lib/config/logs/app_logger.dart` via `AppLogger`. Never instantiate `Logger` directly in features, screens, or blocs.

*Always apply these rules when generating or refactoring code in this project.*
