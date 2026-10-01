# Tarpon Reach — moved

Tarpon Reach is now Android-only and lives in its own repository, with its
full history: https://github.com/abdulalrubat-bit/tarpon-reach

What is left here:

- `index.html` — a page saying where the game went, for old links.
- `sw.js` — a self-removing service worker. The browser build installed one
  that served the game cache-first; this replacement clears that cache and
  unregisters itself the next time an old visitor opens the page.
