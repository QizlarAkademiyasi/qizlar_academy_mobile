# Dependency'lar ko‘rinishi va release build sozlamalari (Flutter)

Bu hujjatning maqsadi: Flutter loyihada ishlatiladigan package/pluginlar qanday “ko‘rinishi”ni tushuntirish va release build’da ularning izlarini kamaytiradigan (lekin 100% yashirmaydigan) amaliy sozlamalarni qisqa ko‘rsatib berish.

## 1) Alohida package yaratib loyihada ishlatish

Siz alohida Dart/Flutter package’ni GitHub (yoki boshqa Git) repo’ga qo‘yib, uni loyihangizda dependency qilib ishlata olasiz.

### Git orqali ulash (oddiy holat)

```yaml
dependencies:
  my_shared_package:
    git:
      url: https://github.com/USERNAME/my_shared_package.git
      ref: main # tavsiya: tag/commit ishlating (masalan v1.2.3)
```

### Mono-repo (repo ichida `packages/...` bo‘lsa)

```yaml
dependencies:
  my_shared_package:
    git:
      url: https://github.com/USERNAME/my_monorepo.git
      path: packages/my_shared_package
      ref: main
```

## 2) “Boshqa package’larni ichiga joylab qo‘ysam ko‘rinmaydimi?”

Yo‘q. Agar sizning package’ingiz ichida boshqa package’lar dependency sifatida turib qolsa, asosiy app’ga ular **transitive dependency** bo‘lib keladi.

- App baribir u dependency’larni **build vaqtida yuklaydi**.
- Ko‘p hollarda dependency ro‘yxati `pubspec.lock`, `.dart_tool/package_config.json`, build log’lar va build artifact’lardan aniqlanadi.

> Xulosa: “Wrapper/shared package” qilish — kodni qayta ishlatish uchun yaxshi. **Dependency’ni yashirish uchun ishonchli yo‘l emas.**

## 3) Scanner/analizatorlar odatda nimani ko‘radi?

Flutter’da dependency’lar 2 turga bo‘linadi:

- **Dart-only package’lar**: faqat Dart kod, native registratsiya yo‘q.
- **Pluginlar**: Android/iOS native qismga ega (Kotlin/Java/ObjC/Swift) va odatda “plugin registratsiya” orqali iz qoldiradi.

Ko‘p scannerlar pluginlarni ko‘proq topadi, chunki:
- Android: `GeneratedPluginRegistrant`, `AndroidManifest.xml`, `Service/Receiver/Provider` classlari kabi izlar bo‘ladi.
- iOS: `GeneratedPluginRegistrant` va CocoaPods/SPM orqali kelgan native framework/klasslar bo‘ladi.

Dart-only package’lar esa release build’da **AOT + tree shaking + obfuscation** sabab kamroq “o‘qiladigan iz” qoldiradi.

## 4) Release build’da “iz”larni kamaytirish (amaliy checklist)

### A) Flutter/Dart obfuscation (tavsiya)

Release build’ni obfuscation bilan qiling:

```bash
flutter build apk --release --flavor prod --obfuscate --split-debug-info=./debug-symbols
```

Yoki:

```bash
flutter build appbundle --release --flavor prod --obfuscate --split-debug-info=./debug-symbols
```

```bash
flutter build ipa --release --obfuscate --split-debug-info=./debug-symbols
```

(iOS’da alohida flavor scheme’lar bo‘lmasa `--flavor` ishlatilmaydi; Android APK/App Bundle uchun `--flavor prod` / `dev` qo‘shiladi.)

- `--obfuscate`: Dart symbol nomlarini chalkashtiradi.
- `--split-debug-info`: mapping/symbol fayllarni alohida papkaga chiqaradi.

> Eslatma: bu jarayon crash stacktrace’larni o‘qish uchun ham kerak bo‘ladi. `./debug-symbols` papkasini yo‘qotmang.

### B) Android: R8 minify/shrinking (tavsiya)

`android/app/build.gradle.kts` ichida `release` buildType’da:
- `isMinifyEnabled = true` (R8)
- (ixtiyoriy) `isShrinkResources = true`

yoqilishi “iz”larni kamaytiradi.

> Muhim: `isShrinkResources = true` ba’zan kerakli resource’larni kesib yuborishi mumkin. Release’da tekshirib chiqing.

### C) iOS: release stripping

Release/Profile uchun Runner target’da strip va dead code stripping aniq yoqilgan bo‘lishi tavsiya etiladi. Crash tahlili uchun **dSYM**ni saqlang.

## 5) Plugin qilsam (Flutter plugin) ko‘rinmay qoladimi?

Ko‘pincha yo‘q — plugin native tomonda registratsiya va dependency izlarini qoldiradi.

Lekin “package’larni yashirish”ga kafolat bermaydi.

## 6) Muhim cheklovlar (realistik xulosa)

- Obfuscation/minify — **qisman** yashiradi, **100% yashirmaydi**.
- Dependency’ni yashirishga urinishdan ko‘ra, ko‘pincha eng to‘g‘ri yo‘l:
  - dependency’larni **minimal** saqlash,
  - keraksiz package’larni olib tashlash,
  - release build’ni to‘g‘ri (obfuscation/minify) qilish,
  - CI/build jarayonida lock/config fayllarni ehtiyotkor boshqarish.

## 7) Tezkor “nima qilish kerak?” (1 minutlik ro‘yxat)

- `pubspec.yaml`da shared package’ni Git/path orqali ulang (kerak bo‘lsa mono-repo `path:` bilan).
- Release build’da:
  - `--obfuscate --split-debug-info=...` bilan build qiling.
  - Android release’da R8 yoqilgan bo‘lsin (`isMinifyEnabled`, ixtiyoriy `isShrinkResources`).
- Shuni biling: bu “ko‘rinmaslik”ni kafolatlamaydi, faqat izlarni kamaytiradi.

## 8) Bu repoda qo‘llangan sozlamalar (qisqa)

- **Android**: `android/app/build.gradle.kts` — release uchun R8 (`isMinifyEnabled`, `isShrinkResources`) va `android/app/proguard-rules.pro`.
- **iOS**: `Runner` target — Release va Profile uchun `DEAD_CODE_STRIPPING`, `STRIP_INSTALLED_PRODUCT`, `STRIP_SWIFT_SYMBOLS`.
- **Release buyruqlar**: `README.md` ichida `--obfuscate --split-debug-info=./debug-symbols` namunalari; `debug-symbols/` `.gitignore`da.
- **Flavor**: faqat **Android**’da `dev` / `prod` — store build uchun odatda `--flavor prod` (APK/App Bundle).
