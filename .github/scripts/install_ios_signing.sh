#!/bin/bash
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
signing_json="$root/assets/credentials/ios_signing.json"
p12="$root/assets/credentials/ios_distribution.p12"
profile="$root/assets/credentials/ios_appstore.mobileprovision"
p12_password="$(node -e "process.stdout.write(require(process.argv[1]).p12_password)" "$signing_json")"
keychain_password="$(openssl rand -base64 24)"
keychain_path="${RUNNER_TEMP}/app-signing.keychain-db"

security create-keychain -p "$keychain_password" "$keychain_path"
security set-keychain-settings -lut 21600 "$keychain_path"
security unlock-keychain -p "$keychain_password" "$keychain_path"
security import "$p12" -P "$p12_password" -A -t cert -f pkcs12 -k "$keychain_path"
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$keychain_password" "$keychain_path"
security list-keychains -d user -s "$keychain_path" login.keychain-db

profile_uuid="$(security cms -D -i "$profile" | plutil -extract UUID raw -)"
profile_dir="$HOME/Library/MobileDevice/Provisioning Profiles"
mkdir -p "$profile_dir"
cp "$profile" "$profile_dir/$profile_uuid.mobileprovision"

# App Store profile uses production push. The checked-in entitlement stays
# development for local debug builds.
sed -i '' 's/<string>development<\/string>/<string>production<\/string>/' \
  "$root/ios/Runner/Runner.entitlements"

# Local Xcode stays on automatic signing. CI release builds use this profile.
cat >> "$root/ios/Flutter/Release.xcconfig" <<'EOF'
CODE_SIGN_STYLE=Manual
CODE_SIGN_IDENTITY=Apple Distribution
PROVISIONING_PROFILE_SPECIFIER=qizlar_academy_ci
DEVELOPMENT_TEAM=C8ASSFN5K9
EOF
