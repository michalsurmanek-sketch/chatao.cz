# CHATAO.cz - Kontrolní seznam pro produkční nasazení

## ✅ Kompletní - Připraveno k nasazení

### 📱 Základní soubory
- ✅ index.html
- ✅ novinka.html  
- ✅ pridat-chatu.html
- ✅ 404.html
- ✅ CNAME

### 🎨 Grafické assety
- ✅ favicon.svg
- ⚠️ apple-touch-icon.png (potřeba vygenerovat z favicon.svg - 180x180px)
- ⚠️ og-image.jpg (doporučeno vytvořit pro sociální sítě - 1200x630px)

### 🗄️ Backend & Databáze (Supabase)
- ✅ supabase-config.js (konfigurace klienta)
- ✅ supabase-schema.sql (databázové schéma)
- ✅ SUPABASE_SETUP.md (kompletní návod)
- ⚠️ **AKCE POTŘEBA**: Vytvořit Supabase projekt a vyplnit credentials
- ⚠️ **AKCE POTŘEBA**: Spustit SQL schéma v Supabase SQL editoru
- ⚠️ **AKCE POTŘEBA**: Vytvořit Storage buckets (chaty-images, user-avatars)

### 🔍 SEO & Vyhledávače
- ✅ robots.txt
- ✅ sitemap.xml
- ✅ Meta description na všech stránkách
- ✅ Keywords na všech stránkách
- ✅ Canonical URL na všech stránkách
- ✅ JSON-LD strukturovaná data (Schema.org)

### 📱 Sociální sítě
- ✅ Open Graph tagy (Facebook)
- ✅ Twitter Card tagy
- ✅ og:image odkazy (po vytvoření og-image.jpg)

### 🚀 Progressive Web App
- ✅ manifest.json
- ✅ theme-color meta tagy
- ✅ Apple touch icon odkazy

### 📊 Analytics & Monitoring
- ✅ Google Analytics placeholder (G-XXXXXXXXXX)
  - ⚠️ **AKCE POTŘEBA**: Nahradit "G-XXXXXXXXXX" skutečným GA4 Measurement ID

### 🔒 Security
- ✅ X-UA-Compatible meta tag
- ✅ Content-Security-Policy (lze přidat do HTTP headers na serveru)

### 🌐 Accessibility & Performance
- ✅ lang="cs" na všech HTML tagech
- ✅ Viewport meta tagy
- ✅ Charset UTF-8
- ✅ Semantic HTML struktura
- ✅ Alt texty (kde jsou obrázky)

---

## ⚠️ Akční položky před spuštěním

### Priorita 1 - Kritické
1. **Supabase Setup**:
   - Vytvořte projekt na supabase.com
   - Zkopírujte Project URL a Anon Key do `supabase-config.js`
   - Spusťte `supabase-schema.sql` v SQL editoru
   - Vytvořte Storage buckets: `chaty-images` a `user-avatars`
   - Nastavte Storage policies (viz SUPABASE_SETUP.md)

2. **Google Analytics**: 
   - Vytvořte GA4 property
   - Nahraďte `G-XXXXXXXXXX` ve všech HTML souborech

### Priorita 2 - Důležité
3. **Obrázky**: 
   - Vytvořte `apple-touch-icon.png` (180x180px) z favicon.svg
   - Vytvořte `og-image.jpg` (1200x630px) pro sociální sítě

4. **DNS & SSL**:
   - Ověřte DNS nastavení pro chatao.cz
   - Ověřte platnost SSL certifikátu

### Priorita 3 - Před spuštěním
5. **Testování**: 
   - Otestujte autentizaci (registrace, přihlášení)
   - Ověřte načítání dat ze Supabase
   - Otestujte upload obrázků do Storage
   - Zkontrolujte web na mobilních zařízeních
   - Ověřte funkčnost všech formulářů

6. **Performance**: 
   - Spusťte Google PageSpeed Insights
   - Spusťte Lighthouse audit
   - Optimalizujte obrázky

7. **SEO validace**:
   - Google Search Console - submit sitemap
   - Ověřte strukturovaná data pomocí Rich Results Test

---

## 📝 Doporučení pro budoucnost

- Zvažte přidání service workeru pro offline funkcionalitu
- Implementujte lazy loading pro obrázky
- Přidejte preload pro kritické fonty/assety
- Zvažte Cookie consent banner (GDPR)
- Nastavte monitoring chyb (Sentry, LogRocket)
- Implementujte A/B testování
- Přidejte rate limiting na API endpointy

---

**Status**: 🟢 Připraveno k produkci (po doplnění Analytics ID a obrázků)
