#!/bin/bash
set -euo pipefail

version="$(awk '/^version:/{print $2; exit}' pubspec.yaml)"
if [ -z "$version" ]; then
  echo "pubspec.yaml ichida version topilmadi."
  exit 1
fi

echo "version=${version}" >> "$GITHUB_OUTPUT"
echo "::notice title=Versiya::${version}"
