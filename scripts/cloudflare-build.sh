#!/bin/sh
set -eu
# Production uses the real domain; branch previews use their own Pages URL.
if [ "${CF_PAGES_BRANCH:-main}" = "main" ]; then
  hugo --minify --gc --baseURL "https://yuukage.com/"
else
  hugo --minify --gc --baseURL "${CF_PAGES_URL:-https://yuukage.com/}"
fi
