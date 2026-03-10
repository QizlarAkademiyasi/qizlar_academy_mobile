---
name: qizlar-academy-project
description: Project-specific rules for qizlar_academy_mobile. Enforces Flutter clean architecture (config/core/feature, Page/View/Mixin, Bloc, components, GoRouter, GetIt) and mandates that all third-party packages come from packages/qizlar_academy_kit/pubspec.yaml; root app must not add new dependencies. Use when editing this project, adding features, screens, or dependencies.
---

# Qizlar Academy — Project skill

This skill applies **only** to the qizlar_academy_mobile project. Follow it together with the global Flutter clean architecture skill when both apply.

## Mandatory: packages only from the kit

- **All third-party packages** used by the app must be declared in **[packages/qizlar_academy_kit/pubspec.yaml](packages/qizlar_academy_kit/pubspec.yaml)**.
- The **root** [pubspec.yaml](pubspec.yaml) must **not** add new third-party dependencies. It may only depend on:
  - `flutter`, `flutter_localizations` (SDK)
  - `qizlar_academy_kit` (path)
  - Any dev-only or app-specific tooling the team explicitly allows in the root.
- When the app needs a new capability (e.g. a new library): **add the dependency to the kit’s pubspec**, then use it in the app (transitively). Do not add it to the root pubspec.
- In lib code, **prefer** importing from `package:qizlar_academy_kit/qizlar_academy_kit.dart` for anything the kit re-exports (Flutter, go_router, flutter_bloc, get_it, equatable, firebase_*, shared_preferences, etc.). For other kit dependencies not yet in the barrel file, add an export in the kit and import the kit, or use the package import; the dependency must still live only in the kit.

## Architecture (this project)

- Follow the structure and patterns in **[reference.md](reference.md)** for this repo.
- **lib:** `main.dart`, `app.dart`, `config/`, `core/`, `feature/`.
- **Feature:** `domain/`, `data/`, `presentation/` (screens/, bloc/, components/ as in reference).
- **Router:** `config/router/app_routes.dart`, `path_routes.dart` (part of app_routes).
- **DI:** `config/di/setup_locator.dart` (GetIt); register repositories and blocs in the kit or in app config as per reference.
- **Screens:** Page/View/Mixin pattern; mixin holds navigation, bloc listeners, lifecycle; build only in page/view. UI bloklarni komponentlarga ajratish va mixin orqali chaqirish qoidalari — reference.md bo‘limi **5.1 Mixin va componentlarga ajratish qonuniyatlari**.

## Full project rules

See **[reference.md](reference.md)** for:

- Exact folder layout and naming
- Kit package list and import conventions
- Feature, config, and core structure
- Bloc, mixin, and component rules (including mixin/component ajratish qonuniyatlari, §5.1) for this project

Do not deviate from reference.md when adding or refactoring code in this project.
