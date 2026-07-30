#!/usr/bin/env bash
# Push _min Tauri apps (sequential).
# Usage: ./push-all.sh              # all 6 apps
#        ./push-all.sh redis_min    # only redis_min
#        ./push-all.sh kafka_ui_min elastic_min
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

  if [ -n "$(cd "$dir" && git status --porcelain)" ]; then
    log "!!! $app: working tree not clean, skipping (commit first)"
    FAILED+=("$app (dirty)")
    continue
  fi

  log "$app: git push"
  if ! (cd "$dir" && git push); then
    log "!!! $app: push FAILED, continuing with next app"
    FAILED+=("$app (push failed)")
    continue
  fi
  log "$app: done"
done

ELAPSED=$(( $(date +%s) - START ))
log "=== All done in ${ELAPSED}s ==="
if [ ${#FAILED[@]} -gt 0 ]; then
  log "FAILED: ${FAILED[*]}"
  exit 1
fi
log "OK: ${APPS[*]}"
