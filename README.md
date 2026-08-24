# qizlar_academy_mobile

Flutter ilovasi (Android’da `dev` / `prod` flavor’lar).

## Build konfiguratsiyasi (`build.json`)

Build paytida binary ichiga yoziladigan qiymatlar (`--dart-define`) bitta
faylda turadi. **Har qanday build shu fayl orqali qilinadi.**

Birinchi marta:

```bash
cp build.example.json build.json
```

`build.json` — `.gitignore` da (ichida Watchdog client kaliti bor, repoga
tushmasin). Shablon `build.example.json` esa repoda saqlanadi — yangi kalit
qo‘shsangiz, ikkalasiga ham qo‘shing.

| Kalit | Nima |
|---|---|
| `WATCHDOG_SERVER_URL` | Watchdog server manzili, **origin** ko‘rinishida (`wss://watchdog.domen.uz`). Yo‘l qo‘shmang — paket `/ws/app` ni o‘zi qo‘shadi |
| `WATCHDOG_CLIENT_API_KEY` | Serverdagi `.env` faylidagi `WATCHDOG_CLIENT_API_KEY` bilan bir xil |
| `GOOGLE_SIGN_IN_WEB_CLIENT_ID` | Firebase **Web** OAuth client ID. Bo‘sh qoldirilsa koddagi fallback ishlatiladi |

Keyin har bir buyruqqa `--dart-define-from-file=build.json` qo‘shiladi:

```bash
flutter run --flavor dev --dart-define-from-file=build.json
```

Watchdog qiymatlari koddagi default’lardan ham keladi
([watchdog_bootstrap.dart](lib/core/watchdog/watchdog_bootstrap.dart)), shuning
uchun oddiy `flutter run` ham serverga ulanadi. `build.json` ularni **ustidan
yozadi** — lokal serverga yoki boshqa muhitga yo‘naltirish shu orqali qilinadi.

Noto‘g‘ri qiymat berilsa cloud o‘chadi va konsolda sabab yoziladi; ilova lokal
rejimda ishlayveradi.

Batafsil: [docs/watchdog.md](docs/watchdog.md).

## Release build (obfuscation va debug symbol’lar)

Store yoki mijozga beriladigan **release** artefaktlarni Dart obfuscation bilan yig‘ish tavsiya etiladi. Symbol fayllarni `debug-symbols/` papkasida saqlang (papka `.gitignore`da — repoga commit qilmang).

**Prod** (odatiy store build):

```bash
flutter build apk --release --flavor prod \
  --dart-define-from-file=build.json \
  --obfuscate --split-debug-info=./debug-symbols
```

```bash
flutter build appbundle --release --flavor prod \
  --dart-define-from-file=build.json \
  --obfuscate --split-debug-info=./debug-symbols
```

```bash
flutter build ipa --release \
  --dart-define-from-file=build.json \
  --obfuscate --split-debug-info=./debug-symbols
```

iOS tomonda hozircha alohida Xcode flavor’lar yo‘q — `ipa` uchun `--flavor` kerak emas. Android **APK/App Bundle** uchun `prod` / `dev` flavor ishlating.

- **Android**: `android/app/build.gradle.kts` — release uchun **R8** (`isMinifyEnabled`, `isShrinkResources`) va `android/app/proguard-rules.pro`.
- **iOS**: Runner target — Release/Profile uchun **strip** va **dead code stripping** (binary’da ortiqcha simvollar kamayadi). Crash tahlili uchun **dSYM**ni saqlang.

Batafsil: [docs/dependency-visibility.md](docs/dependency-visibility.md).

### Shorebird

Flutter argumentlari `--` dan keyin uzatiladi:

```bash
shorebird release android --flavor prod -- --dart-define-from-file=build.json
```

```bash
shorebird patch android --flavor prod -- --dart-define-from-file=build.json
```

Patch va release **bir xil** `build.json` bilan qilinishi shart — aks holda
patch boshqa serverga qarab ketadi.

## Getting Started

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

[online documentation](https://docs.flutter.dev/)
