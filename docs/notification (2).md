# Notification (Topic) moduli — API hujjati

## Yangiliklar (client uchun muhim)

- **Layk/izoh push bildirishnomalari** — endi kimdir sizning postingizga like bossa yoki izoh qoldirsa (yoki izohingizga javob yozsa), push va in-app bildirishnoma keladi. Buning uchun client tarafdan hech qanday qo'shimcha so'rov yuborish shart emas — avtomatik ishlaydi.
- **`GET /api/v1/notification` javobiga yangi maydonlar qo'shildi:** `category`, `actors`, `post` (pastda, 3-bo'limda batafsil).
- **Yangi topic paydo bo'ladi:** "Layk va izohlar" (yoki admin qo'ygan nom) — bu topic **default holatda yoqilgan**, ya'ni hech narsa qilmasangiz ham like/comment push kelaveradi. O'chirib qo'yish uchun oddiy topic ro'yxatidan (`GET /notification-topic`) topib, toggle qilish kifoya — boshqa topic'lardan farqi yo'q, alohida ishlov berish shart emas.
- **Muhim UX nuance:** like/comment push'i **darhol kelmasligi mumkin** — bir necha kishi qisqa vaqt ichida (~10 daqiqagacha) like/comment qilsa, ular Instagram'dagidek bitta bildirishnomaga guruhlanadi ("Aziza va yana 2 kishi postingizga like bosdi"). Shuning uchun test qilayotganda push darhol kelmasa, bu xato emas — kutish kerak.

---

Foydalanuvchi tarafda push bildirishnoma olish 2 bosqichdan iborat:

1. **Push token ro'yxatdan o'tkazish** — qurilma Firebase tokenini backendga yuboradi va `global` kanaliga obuna bo'ladi
2. **Mavzuga (topic) obuna bo'lish** — foydalanuvchi qiziqqan mavzularni (masalan, "Yangi kurslar") tanlab obuna bo'ladi

Token bo'lmasa, topic'ga obuna faqat DB'da (`topicSubscription`) yoziladi — Firebase tarafida push kelmaydi, chunki yuborish uchun qurilma tokeni kerak.

---

## 1. Push tokenni ro'yxatdan o'tkazish

### POST /api/v1/notification/subscribe

JWT talab qiladi. Qurilma tokenini saqlaydi (bitta user = bitta token, `upsert`) va `global` kanaliga Firebase orqali obuna qiladi.

**So'rov tanasi:**

| Maydon  | Turi   | Majburiy | Tavsif           |
| ------- | ------ | -------- | ----------------- |
| `token` | string | Ha       | Qurilma push tokeni (Firebase) |

**Javob:** `204 No Content`

---

### DELETE /api/v1/notification/unsubscribe

JWT talab qiladi. Tokenni DB'dan o'chiradi va `global` kanalidan Firebase obunasini bekor qiladi.

**So'rov tanasi:** yuqoridagi bilan bir xil (`token`)

**Javob:** `204 No Content`

---

## 2. Mavzular (topics)

Mavzular admin tomonidan yaratiladi (masalan: "Yangi kurslar" → key: `new_course`). Foydalanuvchi ularning ichidan o'zi xohlaganiga obuna bo'ladi.

### GET /api/v1/notification-topic — Mavzular ro'yxatini olish

JWT talab qiladi. Barcha mavzularni foydalanuvchining **shu paytdagi obuna holati** bilan birga qaytaradi.

**Query parametrlar:**

| Parametr     | Turi    | Majburiy | Tavsif                              |
| ------------ | ------- | -------- | ------------------------------------ |
| `pageNumber` | integer | Yo'q     | Sahifa raqami (default: 1)           |
| `pageSize`   | integer | Yo'q     | Sahifadagi elementlar (default: 10)  |

**Javob:**

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "data": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "topic": "Yangi kurslar",
        "isSubscribed": true
      },
      {
        "id": "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
        "topic": "Faollik eslatmalari",
        "isSubscribed": false
      }
    ],
    "meta": {
      "pagination": { "pageNumber": 1, "pageSize": 10, "count": 2, "pageCount": 1 }
    }
  }
}
```

`key` maydoni (Firebase identifikatori) client javobida ko'rinmaydi — faqat admin javobida bor.

---

### POST /api/v1/notification-topic/:id/toggle — Obuna bo'lish / bekor qilish

JWT talab qiladi. Bitta endpoint ikkala amalni ham bajaradi:

- Foydalanuvchi hozir obuna **bo'lmasa** → obuna qiladi (`topicSubscription.create` + Firebase `subscribeToTopic`)
- Foydalanuvchi hozir obuna **bo'lsa** → obunani bekor qiladi (`topicSubscription.delete` + Firebase `unsubscribeFromTopic`)

**Path parametr:** `id` — mavzu UUID

**Javob:**

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": { "isSubscribed": true }
}
```

**Muhim:** Agar foydalanuvchida hali push token ro'yxatdan o'tkazilmagan bo'lsa (bo'lim 1 bajarilmagan bo'lsa), Firebase tarafidagi `subscribeToTopic`/`unsubscribeFromTopic` chaqirilmaydi — faqat DB holati o'zgaradi. Shuning uchun mobil ilova avval `/notification/subscribe` ni, keyin topic toggle'ni chaqirishi kerak.

---

## 3. Bildirishnomalar ro'yxati

### GET /api/v1/notification — Bildirishnomalarni olish

JWT talab qiladi. Foydalanuvchiga tegishli barcha bildirishnomalarni (global e'lonlar + shaxsan o'ziga tegishli like/comment/reply push'lari) bitta ro'yxatda, o'qilgan/o'qilmagan holati bilan qaytaradi.

**Query parametrlar:**

| Parametr     | Turi    | Majburiy | Tavsif                                          |
| ------------ | ------- | -------- | ------------------------------------------------ |
| `pageNumber` | integer | Yo'q     | Sahifa raqami (default: 1)                       |
| `pageSize`   | integer | Yo'q     | Sahifadagi elementlar (default: 10)              |
| `type`       | string  | Yo'q     | `global` yoki `push` bo'yicha filter             |

**Javob:**

```json
{
  "statusCode": 200,
  "message": "OK",
  "data": {
    "data": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "title": "❤️ Yangi layk",
        "body": "Aziza Akbarova va yana 2 kishi postingizga layk bosdi",
        "type": "push",
        "category": "POST_LIKED",
        "photo": "https://.../aziza-avatar.jpg",
        "actors": [
          { "id": "u1", "firstname": "Aziza", "lastname": "Akbarova", "photo": "https://.../aziza-avatar.jpg" },
          { "id": "u2", "firstname": "Gulnoza", "lastname": "Jasurova", "photo": "https://.../gulnoza-avatar.jpg" }
        ],
        "post": {
          "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
          "thumbnail": "https://.../post-thumb.jpg"
        },
        "targetId": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
        "isRead": false,
        "createdAt": "2026-01-10T10:30:00.000Z"
      },
      {
        "id": "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
        "title": "🎓 Yangi kurs chiqdi!",
        "body": "Bizda yangi kurs paydo bo'ldi...",
        "type": "global",
        "category": null,
        "photo": "",
        "actors": null,
        "post": null,
        "targetId": null,
        "isRead": true,
        "createdAt": "2026-01-09T09:00:00.000Z"
      }
    ],
    "meta": {
      "pagination": { "pageNumber": 1, "pageSize": 10, "count": 2, "pageCount": 1 }
    }
  }
}
```

**Yangi maydonlar (`category`, `actors`, `post`):**

| Maydon     | Turi                                        | Qachon to'ldiriladi                                                                 |
| ---------- | -------------------------------------------- | ------------------------------------------------------------------------------------- |
| `category` | string \| null                               | `POST_LIKED`, `POST_COMMENTED`, `COMMENT_REPLIED` — post faoliyati; global e'lonlarda `null` |
| `actors`   | `{ id, firstname, lastname, photo }[]` \| null | Faqat yuqoridagi 3 kategoriya uchun — guruhdagi eng so'nggi (bittadan uchtagacha) odam, avatarlarni stack qilib ko'rsatish uchun (skrinshotdagi ustma-ust doiralar). Birinchisi eng oxirgi harakat qilgan odam. |
| `post`     | `{ id, thumbnail }` \| null                   | Faqat yuqoridagi 3 kategoriya uchun — `id` postga o'tish uchun, `thumbnail` post rasm/video preview'i (screenshot'dagi o'ng tomondagi kartochka o'rniga qo'yish uchun) |

`title`/`body` matni backend tomonidan tayyor holda keladi (masalan "Aziza va yana 2 kishi postingizga layk bosdi") — client faqat shu matnni ko'rsatadi, o'zi qayta yig'ib chiqarish shart emas. Bosilganda `post.id` (yoki `targetId`) orqali tegishli post sahifasiga o'tkazish kifoya.

---

### GET /api/v1/notification/unread-count, POST .../read-all, POST .../:id/read

O'zgarishsiz qoladi — endi ular shaxsiy (like/comment) bildirishnomalarni ham hisobga oladi, client tarafdan hech narsa o'zgartirish shart emas.

---

## Oqim (device tarafdan)

```
1. Ilova ochilganda / login'dan keyin:
   POST /notification/subscribe { token }   → global kanalga obuna

2. Sozlamalar ekranida mavzular ro'yxati:
   GET /notification-topic                  → har bir topic uchun isSubscribed

3. Foydalanuvchi bir mavzuni yoqadi/o'chiradi:
   POST /notification-topic/:id/toggle      → isSubscribed teskarisiga o'zgaradi

4. Logout / token yangilanganda:
   DELETE /notification/unsubscribe { token } → global kanaldan chiqadi
```
