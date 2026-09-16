# Digital Asset Links

`assetlinks.json` is the site's half of the handshake that lets the Android app
open this origin without a URL bar. The app's half is in
`android/app/src/main/res/values/strings.xml`. Both must agree.

**The fingerprint in this file is a placeholder and the app will show a URL bar
until it is replaced.** That is the expected state right now — nothing is
broken, the key simply does not exist yet.

## Filling it in

The value is the SHA-256 of the certificate Google Play signs releases with,
which is **not** the same as your upload key once Play App Signing is on. Take
it from Play Console rather than from your own keystore:

> Play Console → your app → Test and release → Setup → App signing →
> **App signing key certificate** → SHA-256 certificate fingerprint

Paste that value (the colon-separated uppercase hex) in place of
`REPLACE_WITH_YOUR_UPLOAD_KEY_SHA256`, commit, and wait for Pages to deploy.
Verification is done by Google's servers against the live URL, so the file has
to be published before it takes effect.

Both fingerprints can be listed at once — upload key and Play signing key — and
that is worth doing while testing, so a locally-signed build and a Play build
both verify:

```json
"sha256_cert_fingerprints": [
  "AA:BB:...",   // Play app signing key, from Play Console
  "CC:DD:..."    // your upload key, from: keytool -list -v -keystore upload.keystore
]
```

## Checking it worked

    https://developers.google.com/digital-asset-links/tools/generator

Point it at `https://abdulalrubat-bit.github.io` and the package name. It reads
the live file, so it tells you what Android will see rather than what is in
this repository.
