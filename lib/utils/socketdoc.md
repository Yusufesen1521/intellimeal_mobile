# IntelliMeal WebSocket API Dökümantasyonu

## Genel Bakış

Bu WebSocket sunucusu, kullanıcılar (USER) ve doktorlar (DOCTOR) arasında gerçek zamanlı bildirim ve onay mekanizması sağlar.

---

## Bağlantı

### Endpoint
```
ws://localhost:8080/ws?id={user_id}&role={role}
```

### Parametreler

| Parametre | Tip    | Zorunlu | Açıklama                      |
|-----------|--------|---------|-------------------------------|
| `id`      | string | Evet    | Benzersiz kullanıcı ID'si     |
| `role`    | string | Evet    | `USER` veya `DOCTOR`          |

### Kısıtlamalar

- **USER**: Birden fazla USER aynı anda bağlanabilir
- **DOCTOR**: Sadece 1 DOCTOR bağlanabilir. İkinci DOCTOR bağlantısı reddedilir

### Bağlantı Yanıtı

Başarılı bağlantıda:
```json
{"type": "200"}
```

---

## Mesaj Formatları

### Genel Mesaj Yapısı
```json
{
  "type": "string",
  "user_id": "string (opsiyonel)"
}
```

---

## Mesaj Tipleri

### 1. USER → Server: `generated`

USER, plan oluşturulduğunda bu mesajı gönderir.

**Gönderen**: USER  
**Request**:
```json
{"type": "generated"}
```

**Sonuç**: DOCTOR'a `user_generated_plan` mesajı iletilir.

---

### 2. Server → DOCTOR: `user_generated_plan`

USER plan oluşturduğunda DOCTOR'a gönderilir.

**Alıcı**: DOCTOR  
**Message**:
```json
{
  "type": "user_generated_plan",
  "user_id": "user123"
}
```

---

### 3. DOCTOR → Server: `approved`

DOCTOR, belirli bir kullanıcının planını onayladığında bu mesajı gönderir.

**Gönderen**: DOCTOR  
**Request**:
```json
{
  "type": "approved",
  "user_id": "user123"
}
```

**Sonuç**: Belirtilen `user_id` ile eşleşen USER'a `approved` mesajı iletilir.

---

### 4. Server → USER: `approved`

DOCTOR onayı sonrası ilgili USER'a gönderilir.

**Alıcı**: USER  
**Message**:
```json
{"type": "approved"}
```

---

## Akış Diyagramı

```
┌─────────┐                    ┌─────────┐                    ┌─────────┐
│  USER   │                    │ SERVER  │                    │ DOCTOR  │
└────┬────┘                    └────┬────┘                    └────┬────┘
     │ Connect (?id=u1&role=USER)  │                              │
     │─────────────────────────────>│                              │
     │ {"type": "200"}              │                              │
     │<─────────────────────────────│                              │
     │                              │   Connect (?id=d1&role=DOCTOR)
     │                              │<─────────────────────────────│
     │                              │ {"type": "200"}              │
     │                              │─────────────────────────────>│
     │                              │                              │
     │ {"type": "generated"}        │                              │
     │─────────────────────────────>│                              │
     │                              │ {"type":"user_generated_plan",│
     │                              │  "user_id":"u1"}             │
     │                              │─────────────────────────────>│
     │                              │                              │
     │                              │ {"type":"approved",          │
     │                              │  "user_id":"u1"}             │
     │                              │<─────────────────────────────│
     │ {"type": "approved"}         │                              │
     │<─────────────────────────────│                              │
     │                              │                              │
```

---

## Hata Mesajları

### DOCTOR Bağlantı Hatası
Zaten bir DOCTOR bağlıyken ikinci DOCTOR bağlanmaya çalışırsa:
```json
{
  "type": "error",
  "user_id": "Zaten bir DOCTOR bağlı"
}
```

---

## Örnek Kullanım

### JavaScript (Browser)
```javascript
// USER olarak bağlan
const userSocket = new WebSocket('ws://localhost:8080/ws?id=user123&role=USER');

userSocket.onmessage = (event) => {
  const msg = JSON.parse(event.data);
  if (msg.type === '200') {
    console.log('Bağlantı başarılı');
  } else if (msg.type === 'approved') {
    console.log('Planınız onaylandı!');
  }
};

// Plan oluşturulduğunda
userSocket.send(JSON.stringify({ type: 'generated' }));
```

```javascript
// DOCTOR olarak bağlan
const doctorSocket = new WebSocket('ws://localhost:8080/ws?id=doctor1&role=DOCTOR');

doctorSocket.onmessage = (event) => {
  const msg = JSON.parse(event.data);
  if (msg.type === 'user_generated_plan') {
    console.log(`USER ${msg.user_id} plan oluşturdu`);
    // Planı onayla
    doctorSocket.send(JSON.stringify({ type: 'approved', user_id: msg.user_id }));
  }
};
```

---

## Health Check

### Endpoint
```
GET http://localhost:8080/health
```

### Response
```
200 OK
```

---

## Sunucuyu Çalıştırma

```bash
# Bağımlılıkları yükle
go mod tidy

# Sunucuyu başlat
go run .
```

Sunucu `8080` portunda çalışır.
