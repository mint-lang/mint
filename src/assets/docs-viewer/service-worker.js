const CACHE = '2dc24be688e5b6d2993dde7d520249d0588283de5a8dcaa6225264b689aba4ed'
const PRECACHE_URLS = [
  '/external-stylesheets.css',
  '/icon-120x120.png',
  '/icon-128x128.png',
  '/icon-144x144.png',
  '/icon-152x152.png',
  '/icon-167x167.png',
  '/icon-16x16.png',
  '/icon-180x180.png',
  '/icon-192x192.png',
  '/icon-196x196.png',
  '/icon-256x256.png',
  '/icon-32x32.png',
  '/icon-36x36.png',
  '/icon-48x48.png',
  '/icon-512x512.png',
  '/icon-57x57.png',
  '/icon-72x72.png',
  '/icon-76x76.png',
  '/icon-96x96.png',
  '/index.html',
  '/index.js',
  '/manifest.webmanifest'
]

// On install precache all static resources
self.addEventListener('install', event => {
  event.waitUntil(
    caches
      .open(CACHE)
      .then(cache =>
        Promise.all(
          PRECACHE_URLS.map(url =>
            cache
              .add(url)
              .catch(error => console.log(`Could not cache: ${url} - ${error}!`))
          )
        )
      )
      .then(() => self.skipWaiting())
  )
})

// On activate remove all unused caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches
      .keys()
      .then(cacheNames => cacheNames.filter(cacheName => cacheName !== CACHE))
      .then(cachesToDelete =>
        Promise.all(
          cachesToDelete.map(cacheToDelete => caches.delete(cacheToDelete))
        )
      )
      .then(() => self.clients.claim())
  )
})

self.addEventListener('fetch', event => {
  const url = event.request.url
  const origin = self.location.origin
  const isSameOrigin = url.startsWith(origin)

  let response = null

  // If we are on the same origin
  if (isSameOrigin) {
    // Try to get the response from the cache, and if not available
    // fall back to the "index.html" file.
    response =
      caches
        .match(event.request)
        .then(cachedResponse => cachedResponse || caches.match('/index.html'))
  } else {
    response = fetch(event.request)
  }

  response
    .then(actualResponse => event.respondWith(actualResponse))
})
