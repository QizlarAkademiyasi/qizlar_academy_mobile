# AI Chat backend contract

Bu hujjat mobil ilovadagi `AI Chat` feature uchun backend kontraktidir. Mobil ilova mavjud flavor oqimidan foydalanadi: production host Firebase Remote Config `baseUrl`, development host `devUrl` orqali olinadi. Quyidagi qiymatlar faqat shu hostga nisbiy endpoint path'lardir.

## Umumiy talablar

- Authentication: `Authorization: Bearer <access-token>` majburiy.
- Content-Type: `application/json; charset=utf-8`.
- Response envelope barcha muvaffaqiyatli javoblarda bir xil:

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {}
}
```

- Sana: ISO-8601 UTC (`2026-08-15T17:42:10.124Z`).
- Chat xabarlari `createdAt` bo‘yicha eskidan yangiga tartiblangan bo‘lishi kerak.
- Assistant matni Markdown emas, oddiy UTF-8 text. Mobil ilova matnni hech qanday HTML/Markdown rendererga bermaydi.
- Mobil request uchun backend javob berish SLA'i 18 soniyadan oshmasin (ilova network timeout'i 20 soniya).
- AI faqat server katalogida mavjud va foydalanuvchi ko‘rishi mumkin bo‘lgan kurslarni tavsiya qiladi. Model o‘ylab topgan course ID yoki URL clientga uzatilmasin.

## 1. Chatni ochish

`GET /api/v1/ai-chat/bootstrap`

Foydalanuvchining oxirgi aktiv suhbatini, uning eng so‘nggi 50 ta xabarini va tezkor savollarni qaytaradi. Suhbat hali yaratilmagan bo‘lsa `conversationId: null`, `messages: []` qaytadi. Suhbat birinchi xabar yuborilganda yaratiladi.

### 200 response — yangi chat

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "conversationId": null,
    "messages": [],
    "quickReplies": [
      {
        "id": "popular-courses",
        "label": "Mashhur kurslar",
        "prompt": "Menga hozirgi mashhur kurslarni tavsiya qil"
      },
      {
        "id": "career-start",
        "label": "Kasb tanlash",
        "prompt": "Qaysi kasbni o‘rganishni boshlashim mumkin?"
      },
      {
        "id": "my-next-course",
        "label": "Keyingi kursim",
        "prompt": "O‘qish tariximga qarab keyingi kursni tavsiya qil"
      }
    ]
  }
}
```

### 200 response — mavjud chat

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "conversationId": "conv_01J5Q7YH4R3K2V9M8T1A",
    "messages": [
      {
        "id": "msg_01J5Q80ME6XQ",
        "role": "USER",
        "content": "Dizayn bo‘yicha kurs tavsiya qil",
        "createdAt": "2026-08-15T17:41:30.000Z",
        "courses": []
      },
      {
        "id": "msg_01J5Q82AE7TQ",
        "role": "ASSISTANT",
        "content": "Sizga mos uchta kurs topdim:",
        "createdAt": "2026-08-15T17:41:34.000Z",
        "courses": [
          {
            "id": "course-uuid",
            "title": "Grafik dizayn asoslari",
            "mentorName": "Madina Karimova",
            "imageUrl": "/uploads/courses/design.webp",
            "rating": 4.8,
            "durationSeconds": 21600,
            "reason": "Boshlang‘ich daraja uchun mos"
          }
        ]
      }
    ],
    "quickReplies": []
  }
}
```

## 2. Xabar yuborish

`POST /api/v1/ai-chat/messages`

### Request

```json
{
  "conversationId": "conv_01J5Q7YH4R3K2V9M8T1A",
  "clientMessageId": "mobile-1786815690123456-4",
  "message": "Menga grafik dizayn bo‘yicha boshlang‘ich kurs kerak",
  "locale": "uz",
  "timezone": "UZT"
}
```

Field qoidalari:

| Field | Type | Majburiy | Qoida |
|---|---|---:|---|
| `conversationId` | string/null | yo‘q | `null` bo‘lsa yangi suhbat yaratiladi; boshqa foydalanuvchi suhbati qabul qilinmaydi |
| `clientMessageId` | string | ha | 1–100 belgi; bir user doirasida idempotency key |
| `message` | string | ha | trim qilingandan keyin 1–1000 belgi |
| `locale` | string | ha | `uz`, `ru`, `en`; javob tili uchun |
| `timezone` | string | ha | qurilma time-zone label'i; analitika/kontekst uchun, kritik biznes hisobida ishlatilmaydi |

Bir xil `clientMessageId` qayta yuborilsa, backend yangi user/assistant xabarlar yaratmasdan avvalgi muvaffaqiyatli response'ni qaytarishi shart. Bu mobil ilovadagi “Qayta yuborish” holatini xavfsiz qiladi.

### 200 response

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "conversationId": "conv_01J5Q7YH4R3K2V9M8T1A",
    "clientMessageId": "mobile-1786815690123456-4",
    "messages": [
      {
        "id": "msg_01J5QB1K47PZ",
        "role": "ASSISTANT",
        "content": "Boshlash uchun quyidagi kurslarni tavsiya qilaman:",
        "createdAt": "2026-08-15T17:42:10.124Z",
        "courses": [
          {
            "id": "course-uuid-1",
            "title": "Grafik dizayn asoslari",
            "mentorName": "Madina Karimova",
            "imageUrl": "/uploads/courses/design.webp",
            "rating": 4.8,
            "durationSeconds": 21600,
            "reason": "Boshlang‘ich daraja uchun mos"
          },
          {
            "id": "course-uuid-2",
            "title": "Figma bilan UI/UX",
            "mentorName": "Zilola Xasanova",
            "imageUrl": "https://cdn.example.com/courses/figma.webp",
            "rating": 4.7,
            "durationSeconds": 18000,
            "reason": null
          }
        ]
      }
    ],
    "quickReplies": [
      {
        "id": "compare-courses",
        "label": "Taqqoslash",
        "prompt": "Shu kurslarni taqqoslab ber"
      }
    ]
  }
}
```

`messages` kamida bitta render qilinadigan assistant xabarni saqlashi shart. `content` bo‘sh bo‘lishi mumkin, lekin bunday holda `courses` bo‘sh bo‘lmasligi kerak. Bitta javobda ko‘pi bilan 5 ta kurs qaytarilsin.

## Xabar modeli

| Field | Type | Majburiy | Izoh |
|---|---|---:|---|
| `id` | string | ha | server message ID |
| `role` | enum | ha | `USER` yoki `ASSISTANT` |
| `content` | string | ha | oddiy text; maksimal 4000 belgi |
| `createdAt` | string | ha | ISO-8601 UTC |
| `courses` | array | ha | tavsiya bo‘lmasa `[]` |

## Kurs tavsiyasi modeli

| Field | Type | Majburiy | Izoh |
|---|---|---:|---|
| `id` | string | ha | mavjud course ID; kartadan course detail ochiladi |
| `title` | string | ha | lokalizatsiya qilingan nom |
| `mentorName` | string | ha | mentor to‘liq ismi; yo‘q bo‘lsa `""` |
| `imageUrl` | string | ha | absolute URL yoki mavjud media-relative path; yo‘q bo‘lsa `""` |
| `rating` | number/null | ha | 0–5 |
| `durationSeconds` | integer/null | ha | umumiy davomiylik sekundlarda |
| `reason` | string/null | ha | tavsiya sababi; kelajakdagi UI uchun |

## Tezkor savol modeli

`id`, `label`, `prompt` uchalasi ham bo‘sh bo‘lmagan string bo‘lishi kerak. `label` ekranda ko‘rinadi, `prompt` esa chip bosilganda serverga oddiy user xabari sifatida yuboriladi. Bootstrap'da 0–8 ta, message response'da 0–4 ta quick reply qaytarilishi mumkin.

## Xato javoblari

Backend texnik stack trace yoki model/provider xatosini `message` orqali clientga chiqarmaydi.

| HTTP | Code | Holat |
|---:|---|---|
| 400 | `AI_CHAT_INVALID_MESSAGE` | bo‘sh, 1000 belgidan uzun yoki noto‘g‘ri payload |
| 401 | `UNAUTHORIZED` | token yo‘q yoki yaroqsiz |
| 403 | `AI_CHAT_CONVERSATION_FORBIDDEN` | conversation boshqa userga tegishli |
| 404 | `AI_CHAT_CONVERSATION_NOT_FOUND` | berilgan conversation topilmadi |
| 409 | `AI_CHAT_MESSAGE_IN_PROGRESS` | shu idempotency key hali qayta ishlanmoqda; `Retry-After` yuborilsin |
| 429 | `AI_CHAT_RATE_LIMITED` | rate limit; `Retry-After` yuborilsin |
| 503 | `AI_CHAT_UNAVAILABLE` | AI provider yoki course retrieval vaqtincha ishlamayapti |

```json
{
  "statusCode": 503,
  "message": "AI chat is temporarily unavailable",
  "error": {
    "code": "AI_CHAT_UNAVAILABLE",
    "requestId": "req_01J5QB7J4S2A"
  }
}
```

Mobil UI barcha API xatolarida foydalanuvchiga umumiy xavfsiz xabar ko‘rsatadi; `requestId`, raw response va texnik tafsilotlar faqat markaziy logga yoziladi.

## AI va katalog xavfsizligi

1. LLM chiqargan course ID'lar to‘g‘ridan-to‘g‘ri response'ga uzatilmasin. Tavsiyalar serverdagi course repository orqali qayta topilib, active/published/access-control filtrlari bilan tekshirilsin.
2. Kurs kartasi qiymatlari LLM matnidan emas, ma’lumotlar bazasidagi canonical course yozuvidan olinishi shart.
3. User prompt'i system/developer ko‘rsatmalarini o‘zgartira olmaydi; prompt injection matni oddiy foydalanuvchi kontenti sifatida ko‘riladi.
4. Token, telefon, email va boshqa maxfiy profil qiymatlari provider prompt'iga yuborilmasin. Tavsiya uchun zarur bo‘lsa faqat minimal, pseudonymized learning-history ishlatilsin.
5. Input/output moderatsiyasi va rate limit user ID bo‘yicha serverda qo‘llansin.

## Mobil UI holatlari bilan mapping

| Backend natija | Mobil holat |
|---|---|
| bootstrap kutilmoqda | chat skeleton |
| `messages: []` | logo, salomlashuv va quick replies |
| `messages` bor | xabarlar va kurs kartalari |
| POST kutilmoqda | optimistic user bubble + AI typing indicator |
| POST xato | user bubble saqlanadi + “Qayta yuborish” |
| bootstrap xato | TGS failure + “Qayta urinish” |
| kurs `imageUrl` bo‘sh/yaroqsiz | standart course image fallback |
| assistant `content` bo‘sh, `courses` bor | faqat kurs kartalari |
