#!/usr/bin/env bash
# Move the game into its own repository, WITH its history.
#
#   ./move-to-own-repo.sh last-isle
#
# `git subtree split` rewrites the towerdefence/ subdirectory into a branch
# whose commits are rooted at the repo root — 25 commits, not a flat snapshot,
# so `git log` and `git blame` still work afterwards. The Android wrapper and
# the workflow live at the repo ROOT rather than under towerdefence/, so the
# split does not carry them and they are added on top as one commit.
#
# What deliberately does NOT move: .well-known/assetlinks.json. Digital Asset
# Links must be served from the ORIGIN root — abdulalrubat-bit.github.io/.well-
# known/... — and only the user-site repo can serve that path. A project repo
# publishes under a subdirectory. The file stays here; the app points there.
set -euo pipefail

NAME="${1:?usage: $0 <repo-name>   e.g. last-isle}"
OWNER=abdulalrubat-bit
URL="https://${OWNER}.github.io/${NAME}/"
BRANCH="_move_${NAME}"

command -v git >/dev/null || { echo "git required"; exit 1; }
[ -d towerdefence ] || { echo "run this from the repo root"; exit 1; }

echo "==> splitting towerdefence/ into ${BRANCH} (history preserved)"
git branch -D "$BRANCH" 2>/dev/null || true
git subtree split --prefix=towerdefence -b "$BRANCH" >/dev/null
echo "    $(git rev-list --count "$BRANCH") commits"

TMP="$(mktemp -d)"
echo "==> building the new tree in ${TMP}"
git worktree add --quiet "$TMP" "$BRANCH"

cp -r android "$TMP/android"
mkdir -p "$TMP/.github/workflows"
cp .github/workflows/android.yml "$TMP/.github/workflows/android.yml"
touch "$TMP/.nojekyll"

# The app points at wherever the game is published, and the deep link has to
# agree. These two strings are the whole difference between the old path and
# the new one.
sed -i.bak "s#https://${OWNER}.github.io/towerdefence/#${URL}#" \
  "$TMP/android/app/build.gradle"
sed -i.bak "s#android:pathPrefix=\"/towerdefence\"#android:pathPrefix=\"/${NAME}\"#" \
  "$TMP/android/app/src/main/AndroidManifest.xml"
rm -f "$TMP"/android/app/build.gradle.bak \
      "$TMP"/android/app/src/main/AndroidManifest.xml.bak

git -C "$TMP" add -A
git -C "$TMP" commit -q -m "Bring the Android wrapper and its build across

The game's own history came over with \`git subtree split\`; these live at the
old repository's root rather than inside towerdefence/, so they arrive as one
commit on top. The app's launch URL and deep-link path now point at
${URL}.

.well-known/assetlinks.json stays behind deliberately: Digital Asset Links are
served from the origin root, which only the user-site repository can publish."

cat <<EOF

==> ready. The new history is in: $TMP

Next, once ${OWNER}/${NAME} exists and is empty:

    git -C "$TMP" remote add origin git@github.com:${OWNER}/${NAME}.git
    git -C "$TMP" branch -M main
    git -C "$TMP" push -u origin main

Then in that repo: Settings -> Pages -> deploy from main, and confirm
${URL} serves before deleting towerdefence/ from this one.

Clean up with:  git worktree remove "$TMP" && git branch -D "$BRANCH"
EOF
