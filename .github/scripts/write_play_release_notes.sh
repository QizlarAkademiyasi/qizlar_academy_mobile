#!/bin/bash
set -euo pipefail

version="$1"
track="$2"

if [ "$track" = "internal" ]; then
  internal="ha"
else
  internal="yo'q"
fi

mkdir -p build/whatsnew
note="$(
  cat <<EOF
Versiya: ${version}
Holat: Shorebird prod release
Flavor: prod
Play track: ${track}
Internalga yuklandi: ${internal}
EOF
)"

printf '%s\n' "$note" > build/whatsnew/whatsnew-en-US
printf '%s\n' "$note" > build/whatsnew/whatsnew-uz-UZ
