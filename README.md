# Grensrock 2026 — Steward Planner

Single-page webapp om steward-shifts te plannen voor Grensrock 2026 (Menen, 26–27 juni).
Data wordt **online bewaard** in Supabase: iedereen met de link ziet het rooster (alleen-lezen),
ingelogde gebruikers kunnen bewerken. Wijzigingen syncen live naar andere toestellen.

## Online zetten (GitHub Pages)
1. Maak op GitHub een **lege** repo: `seys-cloud/Grensrock-stewards` (geen README aanvinken).
2. Push deze map (zie commands onderaan).
3. **Settings → Pages → Build and deployment**: Source = *Deploy from a branch*, Branch = `main` / `/ (root)`.
4. De planner staat dan op `https://seys-cloud.github.io/Grensrock-stewards/`.

## Supabase (eenmalig)
1. Open het Supabase-project `xsavpdiupaxikzuqesul` → **SQL Editor**.
2. Plak en run de inhoud van [`supabase-setup.sql`](./supabase-setup.sql).
3. Login-gebruiker: hergebruik de e-mail + wachtwoord van de draaiboek-editor
   (Auth → Users). Bestaat die niet: Auth → Users → *Add user* (Auto Confirm aan).

## Hoe het werkt
- **Bekijken**: open de link → alleen-lezen, live bijgewerkt.
- **Bewerken**: klik rechtsboven **🔒 Inloggen** → e-mail + wachtwoord → bovenbalk wordt 🔓.
  Alle wijzigingen (teams uploaden, posten/timetable bewerken, rooster genereren, drag-and-drop)
  worden automatisch (debounced) naar Supabase geschreven.
- De volledige staat — teams, posten, timetable **én** het gegenereerde/aangepaste rooster —
  zit in één rij (`id = 1`) van de tabel `stewards_planner` als JSON.

## Bestanden
- `index.html` — de planner (Supabase-versie).
- `supabase-setup.sql` — tabel + RLS-policies (publiek lezen, ingelogd schrijven) + realtime.

## Push-commands
```bash
git init
git branch -M main
git add -A
git commit -m "Steward planner: Supabase online opslag + realtime"
git remote add origin https://github.com/seys-cloud/Grensrock-stewards.git
git push -u origin main
```
