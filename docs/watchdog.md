# Watchdog — masofaviy debug

Ilova tarmoq so‘rovlari, loglar, route o‘tishlari, BLoC/DI hodisalari va
lokatsiyani `watchdog-nest` serveriga real vaqtda oqizadi. Serverda ular
PostgreSQL’ga yoziladi va brauzerdagi dashboard orqali **har bir qurilma
alohida** kuzatiladi.

Server kodi: `Loggermen/watchdog-nest` (`README.md` — endpointlar, maskalash,
retention).

## Arxitektura

```
Ilova (watchdog 0.6.3)
   │  ws://host:8080/ws/app?apiKey=…&sessionId=…&appName=…
   ▼
watchdog-nest :8080 ──► PostgreSQL (14 kun)
   │
   │  ws://host:8080/ws/view?token=…&sessionId=…
   ▼
Dashboard (o‘sha serverning `/` manzilida)
```

`sessionId` — qurilmaga bog‘langan **barqaror** id (`SharedPreferences` da
saqlanadi). Shu sababli ilovani qayta ishga tushirish yangi sessiya yaratmaydi,
va dashboard’da bitta qurilmani ochsangiz boshqa qurilmalar trafigi ko‘rinmaydi.

## Ilova serverga qanday ulanadi

**O‘zidan o‘zi ulanmaydi.** Server manzili va kaliti — compile-time
konstantalar: build paytida binary ichiga yoziladi
([lib/core/watchdog/watchdog_bootstrap.dart](../lib/core/watchdog/watchdog_bootstrap.dart)).

Ikkala qiymat `build.json` orqali beriladi:

```json
{
  "WATCHDOG_SERVER_URL": "wss://watchdog.sizning-domen.uz",
  "WATCHDOG_CLIENT_API_KEY": "server .env dagi bilan bir xil kalit"
}
```

Build buyruqlari uchun [README.md](../README.md#build-konfiguratsiyasi-buildjson)ga qarang.

### `WATCHDOG_SERVER_URL` — faqat origin

Paket URL’ni o‘zi yig‘adi va `/ws/app` ni **o‘zi qo‘shadi**. Shuning uchun
manzil yo‘lsiz bo‘lishi shart:

| Qiymat | Natija |
|---|---|
| `wss://watchdog.domen.uz` | `wss://watchdog.domen.uz/ws/app` — to‘g‘ri |
| `wss://watchdog.domen.uz/watchdog` | `wss://watchdog.domen.uz/watchdog/ws/app` — ulanmaydi |
| `ws://localhost:8080` | Faqat emulyatorda. Real telefonda `localhost` — telefonning o‘zi |

HTTPS orqasidagi serverga `wss://`, TLS’siz lokal serverga `ws://`.

Lokal serverga real qurilmadan ulanish uchun kompyuteringizning LAN IP’sini
yozing, masalan `ws://192.168.1.100:8080`, va telefon bilan bir Wi-Fi’da bo‘ling.

### `WATCHDOG_CLIENT_API_KEY`

Serverdagi `.env` faylidagi `WATCHDOG_CLIENT_API_KEY` bilan **aynan bir xil**
bo‘lishi kerak. Mos kelmasa server WebSocket upgrade paytida `401` qaytaradi,
ilova esa jimgina qayta urinaveradi — dashboard’da hech narsa ko‘rinmaydi.

## Tekshirish

Ilova ulangani:

- Ilova konsolida: `[Watchdog Cloud] Connected to wss://… (session: …)`
- Server logida: `App connected: qizlar-academy · <qurilma> (session …)`
- Dashboard’da qurilma **o‘zi paydo bo‘ladi** — qo‘lda ro‘yxatdan o‘tkazish shart emas.

Dashboard: server manzilini brauzerda oching, `WATCHDOG_ADMIN_KEY` bilan kiring →
loyihalar → qurilmalar xaritasi → qurilmani bosing.

## Hech narsa ko‘rinmasa

Tartib bilan tekshiring:

1. **`build.json` ishlatildimi?** `--dart-define-from-file=build.json` siz
   qilingan build default qiymatga — `ws://localhost:8080` ga — ulanmoqchi
   bo‘ladi va cheksiz qayta urinadi. Xato xabari chiqmaydi.
2. **URL’da yo‘l bormi?** Yuqoridagi jadvalga qarang.
3. **Kalitlar mos kelyaptimi?** Serverda `.env`, ilovada `build.json`.
4. **Reverse proxy WebSocket’ni o‘tkazyaptimi?** nginx/Caddy `/ws/app` va
   `/ws/view` uchun `Upgrade` va `Connection` header’larini uzatishi shart.
   Bu eng ko‘p uchraydigan sabab va logda ko‘rinmaydi.
5. **Server tirikmi?** `curl https://<domen>/health` → `{"ok":true,…}`.

## Kalitni almashtirish

Kalit compile-time bo‘lgani uchun uni serverda o‘zgartirsangiz, **o‘rnatilgan
barcha ilovalar aloqani yo‘qotadi** — yangi versiya chiqmaguncha. Kalit binary
ichida turadi, ya‘ni uni ajratib olish mumkin; u maxfiylik chegarasi emas,
tasodifiy trafikdan himoya.

Agar kerak bo‘lsa, `initializeWatchdog()` `serverUrl` va `apiKey`
parametrlarini qabul qiladi — qiymatlarni Firebase Remote Config’dan berish
mumkin (Watchdog’ni masofadan o‘chirib-yoqish imkoni ham shundan keladi).
Buning uchun `AppRemoteConfig.initialize()` ni `setupLocator()` ichidan
oldinga chiqarish kerak: hozir Watchdog undan **oldin** ishga tushadi.

## Reliz oldidan bilish kerak

**iOS — App Store rad etishi mumkin.** `watchdog 0.6.3` → `geolocator` →
`geolocator_apple`, ya‘ni binary’ga CoreLocation linklanadi. `ios/Runner/Info.plist`
da esa `NSLocationWhenInUseUsageDescription` yo‘q. Watchdog lokatsiyani
ishlatmasa ham, Apple’ning statik tahlili buni ushlaydi (ITMS-90683). Purpose
string qo‘shish yoki paketda geolocator’ni ixtiyoriy qilish kerak.

**Har bir foydalanuvchi.** Watchdog `enabled: true` bilan barcha build’larda
yoqilgan. Ya‘ni relizdan keyin **har bir foydalanuvchining** so‘rovlari,
response body’lari va loglari serverga oqadi. Hajm, xarajat va maxfiylik
jihatidan buni bilib turing.

**Telefondagi lokal server.** `global: false` bo‘lgani uchun paket qurilmada
`0.0.0.0:8888` da DevTools serverini ochadi — release’da ham. Bir Wi-Fi’dagi
istalgan odam o‘sha foydalanuvchi trafigini o‘qiy oladi. Production uchun
`global: true` (faqat cloud) xavfsizroq:

```dart
// lib/core/watchdog/watchdog_bootstrap.dart
config: WatchdogConfig(enabled: true, global: true, cloud: …)
```

## Kod qayerda

| Fayl | Vazifasi |
|---|---|
| `lib/core/watchdog/watchdog_bootstrap.dart` | `initializeWatchdog()`, barqaror `deviceId`, `updateWatchdogUser()` |
| `lib/core/watchdog/watchdog_integrations.dart` | Dio interceptor, router observer, GetIt tracking, log helper’lar |
| `lib/config/bootstrap/app_bootstrap.dart` | DI’dan **oldin** ishga tushiradi |
| `lib/core/network/api_client.dart` | Asosiy Dio — interceptor oxirida (yakuniy auth header’lar bilan) |
| `lib/config/di/setup_locator.dart` | Auth Dio + `trackWatchdogGetIt(getIt)` |
| `lib/config/router/app_routes.dart` | `GoRouter(observers: …)` |
| `lib/config/logs/app_logger.dart` | Har bir `AppLogger` chaqiruvini uzatadi |

`Bloc.observer` ni ulash shart emas — `WatchdogRuntime` uni `start()` paytida
o‘zi o‘rnatadi.
