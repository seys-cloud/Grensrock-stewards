/* Grensrock Stewards Planner - service worker */
const CACHE = 'gr-stewards-v4';
const ASSETS = ['./', './index.html', './logo.png', './favicon.png',
  './icon-192.png', './icon-512.png', './manifest.webmanifest',
  './plattegrond-light.png', './plattegrond-dark.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  // Enkel eigen bestanden cachen; Supabase + CDN's altijd live via netwerk
  if (url.origin !== location.origin) return;
  e.respondWith(
    fetch(req).then(res => {
      const cp = res.clone();
      caches.open(CACHE).then(c => c.put(req, cp));
      return res;
    }).catch(() => caches.match(req).then(m => m || caches.match('./index.html')))
  );
});
