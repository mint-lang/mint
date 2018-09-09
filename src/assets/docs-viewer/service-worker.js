const CACHE = '2335049185270eaa96cb28f6b18a1c7fa08f35d8b7efdfbfb6e700d2d1628242';
const RUNTIME = 'runtime';
const PRECACHE_URLS = ['/icon-167x167.png',
'/icon-76x76.png',
'/icon-152x152.png',
'/index.html',
'/icon-57x57.png',
'/icon-128x128.png',
'/icon-180x180.png',
'/icon-36x36.png',
'/icon-256x256.png',
'/icon-196x196.png',
'/icon-512x512.png',
'/icon-96x96.png',
'/icon-16x16.png',
'/icon-32x32.png',
'/index.js',
'/manifest.json',
'/icon-120x120.png',
'/icon-144x144.png'];

// The install handler takes care of precaching the resources we always need.
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE)
      .then(cache => cache.addAll(PRECACHE_URLS))
      .then(self.skipWaiting())
  );
});

// The activate handler takes removes old caches
self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return cacheNames.filter(cacheName => cacheName !== CACHE);
    }).then(cachesToDelete => {
      return Promise.all(cachesToDelete.map(cacheToDelete => {
        return caches.delete(cacheToDelete);
      }));
    }).then(() => self.clients.claim())
  );
});

// The fetch handler serves responses for same-origin resources from a cache.
// If no response is found, it populates the runtime cache with the response
// from the network before returning it to the page.
self.addEventListener('fetch', event => {
  // Skip cross-origin requests, like those for Google Analytics.
  if (event.request.url.startsWith(self.location.origin)) {
    event.respondWith(
      caches.match(event.request).then(cachedResponse => {
        if (cachedResponse) {
          return cachedResponse;
        } else {
          return fetch(event.request)
        }
      })
    );
  }
});