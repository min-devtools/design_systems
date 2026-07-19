#!/usr/bin/env bash
# Bundle _min Tauri apps (sequential) and copy the .app bundles into /Applications.
# Usage: ./bundle-macos-all.sh              # all 4 apps
#        ./bundle-macos-all.sh redis_min    # only redis_min
#        ./bundle-macos-all.sh kafka_ui_min elastic_min
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ALL_APPS=(elastic_min requests_min kafka_ui_min redis_min git_min log_min)
APPS=("${@:-${ALL_APPS[@]}}")

log() { printf '\n\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }

START=$(date +%s)
FAILED=()

for app in "${APPS[@]}"; do
  dir="$PROJECT_ROOT/$app"
  log "=== $app: start ==="

  if [ ! -d "$dir" ]; then
    log "!!! $app: directory not found, skipping"
    FAILED+=("$app (missing dir)")
    continue
  fi

  # Per-app release version — single source of truth, also injected into the footer by vite.
  VERSION="$(tr -d '[:space:]' < "$dir/VERSION")"
  log "$app: npm run tauri build (v$VERSION)"
  if ! (cd "$dir" && npm run tauri build -- --config "{\"version\":\"$VERSION\"}"); then
    log "!!! $app: build FAILED, continuing with next app"
    FAILED+=("$app (build failed)")
    continue
  fi

  bundle_dir="$dir/src-tauri/target/release/bundle/macos"
  app_bundle=$(find "$bundle_dir" -maxdepth 1 -name '*.app' -print -quit 2>/dev/null || true)
  if [ -z "$app_bundle" ]; then
    log "!!! $app: no .app found in $bundle_dir"
    FAILED+=("$app (no .app)")
    continue
  fi

  name=$(basename "$app_bundle")
  log "$app: copying $name -> /Applications"
  rm -rf "/Applications/$name"
  # ditto preserves signatures/xattrs better than cp -R for .app bundles
  ditto "$app_bundle" "/Applications/$name"
  log "$app: done — /Applications/$name"
done

ELAPSED=$(( $(date +%s) - START ))
log "=== All done in ${ELAPSED}s ==="
if [ ${#FAILED[@]} -gt 0 ]; then
  log "FAILED: ${FAILED[*]}"
  exit 1
fi
log "OK: ${APPS[*]}"
