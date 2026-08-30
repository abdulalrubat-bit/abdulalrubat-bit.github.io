# The Rivenmark — web build

Generated. Do not edit anything in this folder by hand.

It is produced by `npm run deploy <dir>` in the [the-rivenmark][repo] repo's
`phaser/` folder, which builds the bundle, copies the thirteen files a player
needs, and stamps `sw.js` with a hash of what it just shipped. Editing a file
here would be overwritten by the next deploy and, worse, would not change the
service worker's cache key — so nobody with the app installed would ever see it.

Unlisted on purpose: nothing on the studio front page links here.

[repo]: https://github.com/abdulalrubat-bit/the-rivenmark
