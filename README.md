# CHATAO.cz

Moderní booking systém přímo přes Instagram chat pro rezervace chat, chalup a dalších služeb.

## 🚀 Technologie

- **Frontend**: HTML5, Tailwind CSS, Vanilla JavaScript
- **Backend**: Supabase (PostgreSQL + Auth + Storage + Realtime)
- **Hosting**: GitHub Pages
- **Domain**: chatao.cz

## 📁 Struktura projektu

```
chatao.cz/
├── index.html              # Hlavní stránka
├── novinka.html           # Demo hybrid vyhledávač
├── pridat-chatu.html      # Formulář pro přidání chaty
├── 404.html               # Chybová stránka
├── favicon.svg            # SVG ikona
├── manifest.json          # PWA manifest
├── robots.txt             # SEO robots
├── sitemap.xml            # Mapa webu
├── supabase-config.js     # Supabase konfigurace a helper funkce
├── supabase-schema.sql    # SQL schéma pro databázi
├── CNAME                  # GitHub Pages doména
├── .env.example           # Šablona pro environment proměnné
├── PRODUCTION_CHECKLIST.md # Kontrolní seznam
├── SUPABASE_SETUP.md      # Návod na Supabase setup
└── README.md              # Tento soubor
```

## 🔧 Instalace a setup

### 1. Supabase Backend

Podrobný návod najdete v [SUPABASE_SETUP.md](SUPABASE_SETUP.md)

**Rychlý start:**

1. Vytvořte projekt na [supabase.com](https://supabase.com)
2. Zkopírujte Project URL a Anon Key
3. Upravte `supabase-config.js`:
```javascript
const SUPABASE_CONFIG = {
  url: 'https://your-project.supabase.co',
  anonKey: 'your-anon-key-here'
};
```
4. Spusťte SQL schéma v Supabase SQL editoru (zkopírujte `supabase-schema.sql`)
5. Vytvořte Storage buckets: `chaty-images` a `user-avatars`

### 2. Google Analytics

V každém HTML souboru nahraďte `G-XXXXXXXXXX` svým skutečným GA4 Measurement ID.

### 3. Environment variables

```bash
cp .env.example .env.local
# Vyplňte své hodnoty
```

### 4. Lokální vývoj

```bash
# Jednoduchý HTTP server
python3 -m http.server 8000
# nebo
npx serve .
```

Otevřete `http://localhost:8000`

## 📊 Databázové schéma

### Hlavní tabulky:

- **chaty** - Seznam chat a chalup
- **reservations** - Rezervace uživatelů
- **favorites** - Oblíbené chaty
- **reviews** - Hodnocení a recenze

Všechny tabulky mají Row Level Security (RLS) pro bezpečnost dat.

## 🔐 Bezpečnost

- ✅ Row Level Security (RLS) na všech tabulkách
- ✅ Public anon key (bezpečný pro frontend)
- ⚠️ Service role key NIKDY nezveřejňujte
- ✅ HTTPS only (GitHub Pages)
- ✅ Content Security Policy meta tagy

## 📱 Features

- ✅ Responsivní design (mobile-first)
- ✅ Progressive Web App (PWA)
- ✅ SEO optimalizováno (meta tagy, sitemap, structured data)
- ✅ Real-time aktualizace přes Supabase
- ✅ Autentizace uživatelů
- ✅ Upload obrázků do cloud storage
- ✅ Oblíbené a recenze
- ✅ Instagram integrace ready

## 🎨 Design system

### Barvy:
- **Pine** (#568B71) - Hlavní brand barva
- **Ember** (#F97316) - Akcenty a CTA
- **Fog** - Neutrální tóny
- **Cream** (#F5F1E8) - Text
- **Ink** (#0B0F0E) - Pozadí

### Komponenty:
- Glass morphism efekty
- Shimmer animace
- Ringline (subtle borders)
- Rounded 4xl (2rem)

## 📈 SEO & Analytics

- ✅ Google Analytics 4
- ✅ Open Graph tagy (Facebook)
- ✅ Twitter Cards
- ✅ JSON-LD structured data
- ✅ Sitemap.xml
- ✅ Robots.txt

## 🚀 Deployment

### GitHub Pages

1. Push do main branch
2. GitHub Actions automaticky nasadí
3. Dostupné na chatao.cz

### Před nasazením zkontrolujte:

Viz [PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md)

## 📚 API Documentation

### Autentizace

```javascript
// Registrace
const user = await Auth.signUp(email, password, metadata);

// Přihlášení
const session = await Auth.signIn(email, password);

// Odhlášení
await Auth.signOut();
```

### Databáze

```javascript
// Načtení chat s filtry
const chaty = await DB.getChaty({
  region: 'Šumava',
  minPrice: 1000,
  maxPrice: 5000,
  capacity: 4
});

// Vytvoření rezervace
const rezervace = await DB.createReservation({
  chata_id: chataId,
  user_id: userId,
  check_in: '2025-07-01',
  check_out: '2025-07-07',
  guests_count: 4,
  total_price: 15000
});
```

### Storage

```javascript
// Upload obrázku
const result = await Storage.uploadImage('chaty-images', path, file);

// Získání URL
const url = Storage.getPublicUrl('chaty-images', path);
```

Kompletní dokumentace v [SUPABASE_SETUP.md](SUPABASE_SETUP.md)

## 🤝 Contributing

1. Fork projekt
2. Vytvořte feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit změny (`git commit -m 'Add AmazingFeature'`)
4. Push do branch (`git push origin feature/AmazingFeature`)
5. Otevřete Pull Request

## 📝 License

Tento projekt je proprietární software. Všechna práva vyhrazena.

## 📧 Kontakt

- Web: [chatao.cz](https://chatao.cz)
- Email: info@chatao.cz

## 🙏 Acknowledgments

- [Supabase](https://supabase.com) - Backend infrastruktura
- [Tailwind CSS](https://tailwindcss.com) - CSS framework
- [GitHub Pages](https://pages.github.com) - Hosting

---

**Status**: 🟢 Ready for production (po dokončení Supabase setup)

Vytvořeno s ❤️ pro moderní booking experience
