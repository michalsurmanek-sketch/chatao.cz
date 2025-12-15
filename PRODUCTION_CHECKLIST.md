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

1. **Google Analytics**: Vytvořte GA4 property a nahraďte `G-XXXXXXXXXX` ve všech HTML souborech
2. **Obrázky**: 
   - Vytvořte `apple-touch-icon.png` (180x180px) z favicon.svg
   - Vytvořte `og-image.jpg` (1200x630px) pro sdílení na sociálních sítích
3. **Testování**: 
   - Otestujte web na mobilních zařízeních
   - Zkontrolujte všechny odkazy
   - Ověřte funkčnost formulářů
4. **DNS**: Ujistěte se, že DNS nastavení pro chatao.cz je správné
5. **HTTPS**: Ověřte platnost SSL certifikátu
6. **Performance**: 
   - Spusťte Google PageSpeed Insights
   - Spusťte Lighthouse audit
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
