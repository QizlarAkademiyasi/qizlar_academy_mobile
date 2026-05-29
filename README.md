# qizlar_academy_mobile

Flutter ilovasi (Android’da `dev` / `prod` flavor’lar).

## Release build (obfuscation va debug symbol’lar)

Store yoki mijozga beriladigan **release** artefaktlarni Dart obfuscation bilan yig‘ish tavsiya etiladi. Symbol fayllarni `debug-symbols/` papkasida saqlang (papka `.gitignore`da — repoga commit qilmang).

**Prod** (odatiy store build):

```bash
flutter build apk --release --flavor prod --obfuscate --split-debug-info=./debug-symbols
```

```bash
flutter build appbundle --release --flavor prod --obfuscate --split-debug-info=./debug-symbols
```

```bash
flutter build ipa --release --obfuscate --split-debug-info=./debug-symbols
```

iOS tomonda hozircha alohida Xcode flavor’lar yo‘q — `ipa` uchun `--flavor` kerak emas. Android **APK/App Bundle** uchun `prod` / `dev` flavor ishlating.

- **Android**: `android/app/build.gradle.kts` — release uchun **R8** (`isMinifyEnabled`, `isShrinkResources`) va `android/app/proguard-rules.pro`.
- **iOS**: Runner target — Release/Profile uchun **strip** va **dead code stripping** (binary’da ortiqcha simvollar kamayadi). Crash tahlili uchun **dSYM**ni saqlang.

Batafsil: [docs/dependency-visibility.md](docs/dependency-visibility.md).

## Getting Started

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

[online documentation](https://docs.flutter.dev/)
