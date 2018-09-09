module Mint
  class ServiceWorker
    SOURCE =
      <<-JS
      // The install handler takes care of precaching the resources we always need.
      self.addEventListener('install', event => {
        event.waitUntil(
          caches.open(CACHE)
            .then(cache => cache.addAll(PRECACHE_URLS))
            .catch(error => console.log(`Oops! ${error}`))
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
      JS

    def self.generate
      new.generate
    end

    def generate
      Dir.cd "dist"

      head =
        <<-JS
        const CACHE = '#{calculate_hash}';
        const RUNTIME = 'runtime';
        const PRECACHE_URLS = [#{files}];
        JS

      Dir.cd ".."

      [head, SOURCE].join("\n\n")
    end

    def files
      Dir
        .glob("**/*")
        .reject { |file| File.directory?(file) }
        .map { |file| "'/#{file}'" }
        .join(",\n")
    end

    def calculate_hash
      Dir
        .glob("**/*")
        .reject { |file| File.directory?(file) }
        .reduce(OpenSSL::Digest.new("SHA256")) do |digest, file|
        digest.update File.read(file)
      end.to_s
    end
  end
end
