#!/bin/bash
set -euo pipefail

platform="$1"
version="$2"
destination="$3"
status="$4"

if [ -z "$version" ]; then
  version="noma'lum"
fi

case "$status" in
  success) holat="muvaffaqiyatli" ;;
  failure) holat="xato" ;;
  cancelled) holat="bekor qilindi" ;;
  *) holat="$status" ;;
esac

if [ "$status" = "success" ] && [ "$destination" = "internal" ]; then
  internal="ha"
else
  internal="yo'q"
fi

if [ "$platform" = "android" ]; then
  title="Android ${version}"
  where="Play track: ${destination}"
  place_label="Play track"
  place_value="$destination"
else
  title="iOS ${version}"
  where="TestFlight. Play internal emas"
  place_label="Manzil"
  place_value="TestFlight"
fi

message="Holat: ${holat}. Shorebird prod release. ${where}. Internalga yuklandi: ${internal}."

if [ "$status" = "success" ]; then
  echo "::notice title=${title}::${message}"
else
  echo "::error title=${title}::${message}"
fi

{
  echo "### ${title}"
  echo ""
  echo "| | |"
  echo "| --- | --- |"
  echo "| Versiya | ${version} |"
  echo "| Holat | ${holat} |"
  echo "| Builder | Shorebird |"
  echo "| Flavor | prod |"
  echo "| ${place_label} | ${place_value} |"
  echo "| Internalga yuklandi | ${internal} |"
} >> "$GITHUB_STEP_SUMMARY"
