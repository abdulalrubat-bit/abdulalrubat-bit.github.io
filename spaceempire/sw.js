/* Tarpon Reach moved to its own repository and became Android-only.
 *
 * Anyone who opened the browser build has its service worker installed, and
 * that worker served the whole game cache-first: left alone, it would keep
 * serving the old game from cache indefinitely. Browsers re-check this file on
 * navigation, so replacing it with this one is how the old cache is cleared:
 * it installs, deletes every cache, unregisters itself, and reloads open tabs
 * onto the "moved" page.
 */
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    for (const key of await caches.keys()) await caches.delete(key);
    await self.registration.unregister();
    for (const client of await self.clients.matchAll({ type: 'window' })) client.navigate(client.url);
  })());
});
