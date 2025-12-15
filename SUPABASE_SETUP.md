# Supabase Setup Guide pro CHATAO.cz

## 📋 Přehled

CHATAO.cz používá Supabase jako Backend-as-a-Service pro:
- 🗄️ PostgreSQL databázi
- 🔐 Autentizaci uživatelů
- 📁 Storage pro obrázky
- ⚡ Real-time subscriptions
- 🔒 Row Level Security (RLS)

---

## 🚀 Rychlý start

### 1. Vytvoření Supabase projektu

1. Přejděte na [supabase.com](https://supabase.com)
2. Vytvořte nový projekt
3. Poznamenejte si:
   - Project URL (např. `https://xyzcompany.supabase.co`)
   - Anon (public) key
   - Service role key (uchovejte v tajnosti!)

### 2. Konfigurace projektu

Otevřete soubor `/supabase-config.js` a nahraďte:

```javascript
const SUPABASE_CONFIG = {
  url: 'https://your-project.supabase.co',  // ← Vaše Project URL
  anonKey: 'your-anon-key-here'              // ← Váš Anon Key
};
```

### 3. Vytvoření databázové struktury

1. V Supabase Dashboard otevřete **SQL Editor**
2. Zkopírujte celý obsah souboru `/supabase-schema.sql`
3. Spusťte SQL příkaz (Run)

To vytvoří:
- ✅ 4 hlavní tabulky (chaty, reservations, favorites, reviews)
- ✅ Indexy pro rychlé vyhledávání
- ✅ Row Level Security policies
- ✅ Triggery pro automatické aktualizace

### 4. Nastavení Storage buckets

V Supabase Dashboard → **Storage**:

1. Vytvořte bucket `chaty-images`:
   - Public bucket: ✅ ANO
   - Allowed MIME types: `image/jpeg, image/png, image/webp`
   - Max file size: 5 MB

2. Vytvořte bucket `user-avatars`:
   - Public bucket: ✅ ANO
   - Allowed MIME types: `image/jpeg, image/png, image/webp`
   - Max file size: 2 MB

### 5. Storage Policies

Pro `chaty-images`:
```sql
-- Všichni mohou číst
CREATE POLICY "Public read access" ON storage.objects
  FOR SELECT USING (bucket_id = 'chaty-images');

-- Pouze přihlášení mohou nahrávat
CREATE POLICY "Authenticated upload" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'chaty-images' AND auth.role() = 'authenticated');
```

Pro `user-avatars`:
```sql
-- Všichni mohou číst
CREATE POLICY "Public read access" ON storage.objects
  FOR SELECT USING (bucket_id = 'user-avatars');

-- Uživatelé mohou nahrávat své avatary
CREATE POLICY "Users upload own avatar" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'user-avatars' 
    AND auth.uid()::text = (storage.foldername(name))[1]
  );
```

---

## 💻 Použití v kódu

### Autentizace

```javascript
// Registrace
const user = await Auth.signUp('email@example.com', 'password123', {
  full_name: 'Jan Novák'
});

// Přihlášení
const session = await Auth.signIn('email@example.com', 'password123');

// Odhlášení
await Auth.signOut();

// Získání aktuálního uživatele
const user = await Auth.getUser();

// Poslech změn
Auth.onAuthStateChange((event, session) => {
  console.log('Auth event:', event, session);
});
```

### Databázové operace

```javascript
// Načtení chat
const chaty = await DB.getChaty({
  region: 'Šumava',
  minPrice: 1000,
  maxPrice: 5000,
  capacity: 4
});

// Vytvoření nové chaty
const novaChata = await DB.createChata({
  name: 'Horská chalupa',
  slug: 'horska-chalupa',
  description: 'Krásná chalupa v horách',
  region: 'Krkonoše',
  capacity: 6,
  price_from: 2500,
  owner_id: user.id
});

// Vytvoření rezervace
const rezervace = await DB.createReservation({
  chata_id: 'uuid-chaty',
  user_id: user.id,
  check_in: '2025-07-01',
  check_out: '2025-07-07',
  guests_count: 4,
  total_price: 15000
});

// Přidání do oblíbených
await DB.addToFavorites(user.id, chataId);
```

### Storage operace

```javascript
// Nahrání obrázku
const file = document.getElementById('fileInput').files[0];
const uploadResult = await Storage.uploadImage(
  'chaty-images',
  `${chataId}/${Date.now()}.jpg`,
  file
);

// Získání public URL
const imageUrl = Storage.getPublicUrl('chaty-images', uploadResult.path);

// Smazání obrázku
await Storage.deleteImage('chaty-images', 'path/to/image.jpg');
```

### Real-time subscriptions

```javascript
// Poslech změn v chatách
const subscription = Realtime.subscribeToChaty((payload) => {
  console.log('Změna v chatách:', payload);
  // Aktualizovat UI
});

// Zrušení subscriptions
subscription.unsubscribe();
```

---

## 🗄️ Databázová struktura

### Tabulka: `chaty`
- Hlavní tabulka pro chaty/chalupy
- Obsahuje lokaci, ceny, vybavení, obrázky
- RLS: Veřejné chaty vidí všichni, ostatní jen majitelé

### Tabulka: `reservations`
- Rezervace uživatelů
- Datumy check-in/check-out, počet hostů, cena
- Status: pending, confirmed, cancelled, completed
- RLS: Uživatelé vidí své rezervace + majitelé chat

### Tabulka: `favorites`
- Oblíbené chaty uživatelů
- Many-to-many vztah user ↔ chata
- RLS: Každý vidí jen své oblíbené

### Tabulka: `reviews`
- Recenze a hodnocení chat
- Overall rating + detail ratings (čistota, lokace, hodnota)
- RLS: Všichni čtou, jen autoi mohou upravovat

---

## 🔐 Bezpečnost

### Row Level Security (RLS)

Všechny tabulky mají zapnuté RLS policies:

✅ **Chaty**: Publikované vidí všichni, nepublikované jen majitelé
✅ **Rezervace**: Vidí jen uživatel a majitel chaty
✅ **Oblíbené**: Každý vidí jen své
✅ **Recenze**: Všichni čtou, upravují jen autoři

### API Keys

⚠️ **NIKDY** neukládejte do gitu:
- Service role key (má plný přístup)
- Privátní klíče

✅ **Bezpečné** pro veřejné použití:
- Anon key (má pouze RLS omezení)
- Project URL

---

## 📊 Monitoring & Analytics

### Supabase Dashboard

- **Table Editor**: Prohlížení a editace dat
- **SQL Editor**: Spouštění SQL dotazů
- **Database**: Správa schématu a replik
- **Auth**: Správa uživatelů a politik
- **Storage**: Prohlížení souborů
- **Logs**: Query logy a chyby

### Metrika sledování

```sql
-- Top 10 nejnavštěvovanějších chat
SELECT name, views_count, bookings_count, rating
FROM chaty
WHERE is_published = true
ORDER BY views_count DESC
LIMIT 10;

-- Rezervace za poslední měsíc
SELECT COUNT(*), SUM(total_price)
FROM reservations
WHERE created_at >= NOW() - INTERVAL '30 days';
```

---

## 🔧 Troubleshooting

### Problém: "Invalid API key"
- Zkontrolujte, že máte správnou URL a anon key v `supabase-config.js`
- Ověřte, že projekt v Supabase je aktivní

### Problém: "Row Level Security policy violation"
- Zkontrolujte, že máte správně nastavené RLS policies
- Ověřte, že uživatel je přihlášen (kde je to vyžadováno)

### Problém: "relation does not exist"
- Ujistěte se, že jste spustili celý `supabase-schema.sql`
- Zkontrolujte v Table Editor, zda tabulky existují

---

## 📚 Další zdroje

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase JS Client](https://supabase.com/docs/reference/javascript/introduction)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Storage Guide](https://supabase.com/docs/guides/storage)

---

**Status**: 🟢 Ready for implementation
