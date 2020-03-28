module Mint
  class ServiceWorker
    SOURCE =
      <<-JS
      // On install precache all static resources
      self.addEventListener('install', event => {
        event.waitUntil(
          caches
            .open(CACHE)
            .then(cache =>  {
              const promises =
                PRECACHE_URLS.map((url) =>
                  cache
                    .add(url)
                    .catch(error => console.log(`Could not cache: ${url} - ${error}!`))
                )

              return Promise.all(promises)
            })
            .then(self.skipWaiting())
        );
      });

      // On activate remove all unused caches
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

      self.addEventListener('fetch', event => {
        const url = event.request.url
        const origin = self.location.origin
        const isSameOrigin = url.startsWith(origin)
        let response = null

        // If we are on the same origin
        if (isSameOrigin) {
          // resolve the path
          const path = url.slice(origin.length)

          // Try to get the response from the cache if not available fall back to
          // the "index.html" file.
          response =
            caches
              .match(event.request)
              .then(cachedResponse => cachedResponse || caches.match("/index.html"))
        } else {
          response = fetch(event.request)
        }

        event.respondWith(response)
      });
      JS

    def self.generate
      new.generate
    end

    def generate
      Dir.cd DIST_DIR

      head =
        <<-JS
        const CACHE = '#{calculate_hash}';
        const RUNTIME = 'runtime';
        const PRECACHE_URLS = [#{files}];
        JS

      Dir.cd ".."

      {head, SOURCE}.join("\n\n")
    end

    def files
      Dir
        .glob("**/*")
        .reject { |file| File.directory?(file) }
        .join(",\n") { |file| "'/#{file}'" }
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
