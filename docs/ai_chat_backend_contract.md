# AI Chat backend contract

Bu hujjat mobil ilovadagi `AI Chat` feature uchun backend kontraktidir. Mobil ilova mavjud flavor oqimidan foydalanadi: production host Firebase Remote Config `baseUrl`, development host `devUrl` orqali olinadi. Quyidagi qiymatlar faqat shu hostga nisbiy endpoint path'lardir.

## Umumiy talablar

- Authentication: `Authorization: Bearer <access-token>` majburiy.
- Content-Type: `application/json; charset=utf-8`.
- Response envelope muvaffaqiyatli JSON javoblarda bir xil:

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {}
}
```

- **ChatGPT uslubidagi ko‘p suhbat** modeli: foydalanuvchida bir nechta nomlangan suhbat bo‘lishi mumkin.
- `POST /messages` da `conversationId` berilsa — o‘sha suhbat davom ettiriladi. `null` yoki berilmasa — **har doim yangi** suhbat yaratiladi.
- Suhbat `title` birinchi xabar-javobdan so‘ng AI tomonidan generatsiya qilinadi (3–5 so‘z). Keyingi xabarlarda o‘zgarmaydi.
- Sana: ISO-8601 UTC.
- Chat xabarlari `createdAt` bo‘yicha eskidan yangiga.
- Assistant matni **Markdown** (`**qalin**`, `-` / `1.` ro‘yxatlar). Mobil UI `flutter_markdown` orqali render qiladi; foydalanuvchi xabari oddiy text.
- AI faqat kurslar mavzusida javob beradi.
- `needsMoreInfo` alohida UI holati emas — `reply` oddiy pufakchada chiqadi.
- Bir javobda ko‘pi bilan **3 ta** kurs (`recommendedCourses`).
- `clientMessageId` har bir yangi xabar uchun yangi, retry da xuddi shu qiymat.

## 1. Chatni ochish

`GET /api/v1/ai-chat/bootstrap`

Eng so‘nggi faol suhbat va so‘nggi (eng ko‘pi 50) xabar. Suhbat yo‘q bo‘lsa `conversationId: null`, `title: null`, `messages: []`.

Tarixiy xabarlarda `recommendedCourseIds` faqat ID massivi — to‘liq kartochkalar **qaytmaydi**. Mobil UI shu ID’larni home/catalog cache va kerak bo‘lsa `GET /course/{id}` orqali hydrate qiladi va assistant xabar ostida `recommendedCourses` kartalarini qayta chizadi. Tartib `recommendedCourseIds` bilan bir xil; topilmagan kurs skip qilinadi, xabar matni chiqaveradi. To‘liq kartochka obyektlari `POST /messages` dagi `recommendedCourses` da ham keladi.

## 2. Suhbatlar ro‘yxati

`GET /api/v1/ai-chat/conversations?pageNumber=1&pageSize=20`

Sidebar/tarix uchun. `title: null` — suhbat yaratilgan, lekin birinchi almashinuv yakunlanmagan.

## 3. Suhbat xabarlarini olish

`GET /api/v1/ai-chat/conversations/:id/messages?pageNumber=1&pageSize=50`

Ro‘yxatdan eski suhbat tanlanganda. Pagination `data` + `meta.pagination`, eskidan yangiga. Mobil UI so‘nggi 50 xabarni ko‘rsatadi.

## 4. Xabar yuborish

`POST /api/v1/ai-chat/messages`

### Request

```json
{
  "conversationId": null,
  "clientMessageId": "mobile-1786815690123456-4",
  "message": "Menga grafik dizayn bo‘yicha boshlang‘ich kurs kerak"
}
```

| Field | Majburiy | Qoida |
|---|---|---|
| `conversationId` | yo‘q | berilsa o‘sha suhbat; `null` bo‘lsa **yangi** suhbat |
| `clientMessageId` | ha | 1–100 belgi; retry da xuddi shu qiymat |
| `message` | ha | trim dan keyin 1–1000 belgi |

`locale` va `timezone` yuborilmaydi.

### Response `data`

- `conversationId`, `clientMessageId`, `title`
- `reply` — assistant matni
- `recommendedCourses` — 0–3 ta to‘liq kurs kartochkasi
- `needsMoreInfo` — boolean; UI alohida ko‘rsatmaydi

Kurs maydonlari: `id`, `name`, `bannerImage`, `icon`, `teacherFullname`, `avgRating`, `totalRatings`, `totalDuration` (**daqiqa**), `lessonCount`. `bannerImage` / `icon` — R2 nisbiy yo‘l; client `Apis.resolveUrl` bilan to‘liq URL qiladi.

Yangi suhbatning birinchi javobida `title` allaqachon to‘ldirilgan holda keladi.

## 5. Yangi suhbat

Alohida create/delete endpoint yo‘q. UI ekranni tozalaydi va keyingi `POST /messages` ni `conversationId: null` bilan yuboradi. Javobdagi `conversationId` va `title` saqlanadi, keyingi xabarlar shu ID bilan davom etadi.

## Xato javoblari

Alohida `AI_CHAT_*` katalogi yo‘q. Standart global format.

| HTTP | Holat |
|---:|---|
| 400 | validatsiya (`message`, `clientMessageId`, UUID) |
| 401 | token yo‘q / yaroqsiz |
| 403 | conversation boshqa userga tegishli |
| 404 | conversation topilmadi |
| 500 | AI/server xatosi; imkon qadar `reply` da xavfsiz matn |

Mobil UI barcha API xatolarida foydalanuvchiga umumiy xavfsiz xabar ko‘rsatadi; texnik tafsilotlar faqat `AppLogger`.

## Mobil UI mapping

| Backend natija | Mobil holat |
|---|---|
| bootstrap kutilmoqda | chat skeleton |
| `messages: []` | logo va salom |
| `messages` bor | xabarlar; `recommendedCourseIds` hydrate qilinib kartalar chiqadi |
| POST kutilmoqda | optimistic user bubble + AI typing |
| POST xato | user bubble + “Qayta yuborish” (shu `clientMessageId`) |
| bootstrap xato | TGS failure + qayta urinish |
| suhbat tanlash | skeleton, so‘ng xabarlar |
| suhbat tanlash xato | TGS failure + qayta urinish |
| “Yangi suhbat” | lokal tozalash, welcome; API chaqirilmaydi |
| `title` kelganda | header va sidebar yangilanadi |
| kurs rasmi bo‘sh | standart course image fallback |
