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
- **lib:** `main.dart`, `app.dart`, `config/` (shu jumladan `config/enum/` — shared enumlar), `core/`, `feature/`.
- **Feature:** `domain/`, `data/`, `presentation/` (screens/, bloc/, components/ as in reference).
- **Ichki ekran (nested screen):** Sub-flow ekran (masalan profil tahriri) bo‘lsa, `presentation/screens/<slug>/` ichida ekran + mixin, `bloc/`, `components/` — batafsil **reference.md §4.1**.
- **Router:** `config/router/app_routes.dart`, `path_routes.dart` (part of app_routes).
- **DI:** `config/di/setup_locator.dart` (GetIt); register repositories and blocs in the kit or in app config as per reference.
- **Logging:** all app logs must go through `lib/config/logs/` (central logger). Use `AppLogger` there; do not instantiate `Logger` directly in features/screens/blocs.
- **Screens:** Page/View/Mixin pattern; mixin holds navigation, bloc listeners, lifecycle; build only in page/view. UI bloklarni komponentlarga ajratish va mixin orqali chaqirish qoidalari — reference.md bo‘limi **5.1 Mixin va componentlarga ajratish qonuniyatlari**.
- **Komponent ichida mixin:** Juda katta kompozitsiyani `presentation/components/` ichida `*_mixin.dart` bilan bo‘lib tashlash (Single Responsibility / tsiklik importdan qochish) mumkin — bu qoidalar reference.md’da aniqlangan.
- **Global toast:** SnackBar o‘rniga `core/presentation/components/app_toast.dart` dagi `AppToast` ishlatiladi (`success`, `error`, `warning`, `info`), va toast ichida `.tgs` animatsiyalar ishlatiladi.
- **Error UX + logging:** API/exception xatoliklarida userga backend xabari yoki stack trace ko‘rsatilmaydi. UI’da faqat umumiy, xavfsiz matn beriladi (masalan: `Ulanishda xatolik yuz berdi. Iltimos, qayta urinib ko‘ring.`). Texnik tafsilotlar esa faqat `AppLogger` orqali loglanadi.

## Responsive horizontal collections (mandatory)

Story, category, chip, carousel va boshqa dinamik horizontal ro‘yxatlar quyidagi talablarni bajarishi shart:

- Backenddan kelgan elementlar sonini viewport kengligiga qarab kesmang va faqat ekranga sig‘adigan itemlarni render qilmang. Explicit product limiti bo‘lmasa, barcha itemlar mavjud bo‘lishi va gorizontal scroll orqali ochilishi kerak.
- `Row` yoki fixed-width wrapper sabab overflow/clipping hosil qilmang. Oddiy holatda `ListView.builder(scrollDirection: Axis.horizontal)`; custom overlap/animation zarur bo‘lsa `SingleChildScrollView` va barcha item, spacing hamda paddingni qamrab oladigan content extent ishlating.
- Boshqa header actionlari uchun qo‘yilgan fixed `left`/`right` inset expanded holatdagi ro‘yxat viewportini doimiy toraytirmasin. Action-zone faqat kerakli state’da rezerv qilinsin; transition bo‘lsa inset layout progress bo‘yicha adaptiv/interpolatsiya qilinsin.
- Expanded/interaktiv holatda horizontal scroll physics faol bo‘lsin. Collapse animatsiyasi paytida gesture conflict sabab vaqtincha o‘chirilsa, expanded holatga qaytganda scroll qayta yoqilishi shart.
- O‘zgarish mavjud collapse animation, header action hit-area, navigation, story view tracking va skeleton holatlarini buzmasligi kerak.
- Har bir shunday fix/refactor uchun widget regression testi yozing. Test viewportdan uzun dataset bilan kamida quyidagilarni tekshirsin:
  - `maxScrollExtent > 0`;
  - horizontal drag’dan keyin scroll position o‘zgaradi;
  - expanded holatda viewport available width’dan foydalanadi;
  - collapsed holatda actionlar uchun kerakli safe zone saqlanadi.
- Imkon qadar narrow va standard viewportlarda tekshiring; test dataset kamida ekranga sig‘maydigan darajada uzun bo‘lsin.

## Store release builds (Play / App Store)

**Maqsad:** store’ga chiqariladigan artefaktlarni [Dart obfuscation](https://docs.flutter.dev/deployment/obfuscate) bilan yig‘ish — tahlil vositalarida paket/sinf nomlari kamroq ochiq ko‘rinadi. Loyiha `android/app/build.gradle.kts` da release uchun **R8** (`isMinifyEnabled`, `isShrinkResources`, `proguard-rules.pro`) allaqachon yoqilgan.

Loyiha ildizidan ( `./` ):

```bash
flutter pub get
flutter build appbundle --flavor prod --obfuscate --split-debug-info=build/debug-info
flutter build ipa --export-method app-store --obfuscate --split-debug-info=build/debug-info
```

- **AAB:** `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- **iOS:** `build/ios/archive/Runner.xcarchive`, IPA `build/ios/ipa/` ichida

**Muhim:** `build/debug-info/` dagi fayllar **store’ga yuklanmaydi**; ularni jamoa ichida xavfsiz saqlang (crash dekodlash / profil). Agar ikon tree-shaking muammo qilishi aniqlansa, `uma_mobile` dagi kabi qo‘shimcha `--no-tree-shake-icons` qo‘llanishi mumkin.

## Full project rules

See **[reference.md](reference.md)** for:

- Exact folder layout and naming
- Kit package list and import conventions
- Feature, config, and core structure
- Bloc, mixin, and component rules (including mixin/component ajratish qonuniyatlari, §5.1) for this project
- **Exception screens va skeleton (§6.1):** fail holatlari uchun `.tgs` animatsiyali `exception_screens` komponentlari (TgsFailureContent); **bo‘sh holatlar** uchun ham `TgsEmptyContent` + quyon `.tgs` (`UiKitAssets.lottie.rabbit.*`) — statik empty ikonlar yozilmaydi; yuklanishda CircularProgressIndicator o‘rniga skeleton (PageLoadingSkeleton yoki feature-specific skeleton) ishlatiladi.

Do not deviate from reference.md when adding or refactoring code in this project.
