# Taj AlAsehaa — Website Redesign

Homepage redesign for **تاج الأصحاء (Taj AlAsehaa)** — Rehabilitation & Health Center, Madinah, KSA.

This package is a complete, hand-off-ready front-end with externalised CSS/JS, JSON content sources, image placeholders, and a starter MySQL schema for the back-end.

---

## 📁 Folder structure

```
tajelsehaa-website/
├── index.html                  # Homepage (RTL, Arabic). Open this in a browser.
├── README.md                   # ← you are here
├── assets/
│   ├── css/
│   │   └── styles.css          # All styles (single file, ~28 KB)
│   ├── js/
│   │   └── main.js             # Scroll-reveal observer
│   └── images/
│       ├── logo.svg            # Brand mark
│       ├── favicon.svg
│       ├── hero-rehab.svg      # ← REPLACE with real photo
│       ├── about-clinic.svg    # ← REPLACE with real photo
│       ├── program-rehab.svg   # ← REPLACE with real photo
│       ├── program-home.svg    # ← REPLACE with real photo
│       └── program-umrah.svg   # ← REPLACE with real photo
├── data/                        # Content as JSON — easy to import into a CMS
│   ├── services.json
│   ├── programs.json
│   ├── testimonials.json
│   └── faq.json
└── database/
    └── schema.sql               # MySQL 8 / MariaDB schema + seed data
```

---

## 🚀 Quick start (front-end only)

```bash
# Any static server works. Examples:
cd tajelsehaa-website
python3 -m http.server 8000
# or
npx serve .
```

Open `http://localhost:8000`.

> The page renders directly from `index.html` — no build step required.

---

## 🔁 Replacing placeholder images

The `assets/images/*.svg` files are **branded SVG placeholders**. Replace each one with a real photograph (JPG or WebP recommended) and update the references:

| Placeholder | Where it appears | Recommended subject |
|---|---|---|
| `hero-rehab.svg` | Hero section right side | Physiotherapist working with a patient |
| `about-clinic.svg` | About section | Clean, well-lit clinic interior |
| `program-rehab.svg` | Programs grid #1 | Patient doing rehab exercises |
| `program-home.svg` | Programs grid #2 | Therapist visiting patient at home |
| `program-umrah.svg` | Programs grid #3 | Calm post-Umrah recovery imagery |

After replacing, update the file extensions in **`assets/css/styles.css`** (search for `program-` and `hero-rehab`) and in `index.html` if needed. Recommended export sizes:

- Hero / about: **1200×1500 @ 80% JPEG**
- Program cards: **800×500 @ 80% JPEG**
- Always also export a **2x retina** version and serve via `srcset` if you can.

---

## 🌐 Languages

The site is built **RTL Arabic** as the primary language. The header has an `EN` toggle wired up for the developer to implement. JSON files contain `*_ar` and `*_en` variants for every text field — connect them to whatever i18n approach your stack uses (Next.js i18n, Laravel localization, etc.).

---

## 🗄️ Back-end / database

`database/schema.sql` contains a ready-to-run **MySQL 8 / MariaDB** schema with 9 tables:

1. `services` — service catalogue
2. `programs` — packaged treatment plans
3. `staff` — doctors and specialists
4. `appointments` — booking requests from the site
5. `contact_messages` — generic enquiries
6. `testimonials` — patient reviews
7. `faqs`
8. `site_settings` — phone / email / hours / social links
9. `admins` — back-office users

```bash
mysql -u root -p < database/schema.sql
```

Seed data for services, programs, testimonials, FAQ and site settings is included so the homepage renders immediately when wired up.

### Recommended back-end stack

Anything works — the front-end just needs JSON. Suggested options:

- **Laravel** (PHP) + MySQL + Filament admin
- **Next.js** + Prisma + the included MySQL schema
- **WordPress** with ACF (treat services/programs as custom post types)
- **Strapi / Directus** — point them at the included schema as a starting point

### Required API endpoints

| Method | Endpoint | Body / params |
|---|---|---|
| `GET`  | `/api/services` | — |
| `GET`  | `/api/programs` | — |
| `GET`  | `/api/testimonials?published=1` | — |
| `GET`  | `/api/faqs` | — |
| `GET`  | `/api/settings` | — |
| `POST` | `/api/appointments` | `full_name, phone, email?, service_id?, preferred_date?, notes?` |
| `POST` | `/api/contact` | `full_name, phone?, email, subject?, message` |

---

## 🎨 Design tokens

Defined as CSS custom properties in `assets/css/styles.css` (search `:root`):

| Token | Value | Usage |
|---|---|---|
| `--teal-900` | `#0b3a45` | Headings, dark surfaces |
| `--teal-700` | `#126676` | Primary brand colour, primary buttons |
| `--teal-500` | `#1ea7b3` | Accents, hover, gradients |
| `--green-600` | `#3aa17e` | "Healing" accent — featured cards, success states |
| `--sand-50` | `#fbf8f3` | Hero soft warm bg |
| `--ink-900 / 700 / 500` | text | Body text scale |
| `--radius / --radius-lg` | 16/24px | Card radii |
| `--shadow-sm / md / lg` | — | Three elevation levels |

**Fonts** (loaded from Google Fonts):
- `Tajawal` 400/500/700/800/900 — display/headings
- `IBM Plex Sans Arabic` 300/400/500/600/700 — body

---

## 📐 Sections in the homepage

1. Top utility bar (hours, location, phone)
2. Sticky header + nav
3. **Hero** — headline, sub, two CTAs, trust stats, decorative photo with floating cards
4. **Why-strip** — 6 chips overlapping the hero (dark teal band)
5. **Services** — 6 cards, gradient top-border on hover
6. **About** — split image + text + 4 highlights
7. **Why Choose Us** — 4 centred icon cards
8. **Featured Programs** — 3 cards with image + tag
9. **Techniques** — dark teal section, 3 numbered cards
10. **Testimonials** — 3 quote cards with star ratings
11. **CTA banner** — full-width, dark teal with green/teal glows
12. **Contact + map** — info column + stylised SVG map placeholder *(replace with embedded Google Maps iframe in production)*
13. **FAQ** — 4 collapsible items
14. **Footer** — 4 columns with social links
15. Floating WhatsApp button (bottom-left)

---

## ✅ Production checklist

- [ ] Replace all `assets/images/*.svg` placeholders with real photos
- [ ] Replace `.contact-map .map-placeholder` with a real Google Maps embed iframe
- [ ] Wire forms (currently `<a>` placeholders) to `/api/appointments` and `/api/contact`
- [ ] Set `<meta>` SEO tags (title, description, og:image, hreflang)
- [ ] Add Google Analytics / Tag Manager
- [ ] Test on mobile (375px) — already responsive but verify
- [ ] Configure CDN + image compression (Cloudflare Images / imgproxy)
- [ ] Add CSP headers and HTTPS

---

## 🧩 Pages still to build (per brief)

After homepage approval, the same design language extends to:

1. About page
2. Service detail pages (one per row in `services`)
3. Booking page (full form posting to `/api/appointments`)
4. Contact page

A `templates/` folder can be added with a shared header/footer partial — the easiest path is to convert this static HTML to a Laravel/Blade or Next.js project and reuse the existing `styles.css` verbatim.

---

**Built for:** Taj AlAsehaa Rehabilitation & Health Center
**Location:** Madinah, Saudi Arabia
**Phone:** +966 57 399 8384
