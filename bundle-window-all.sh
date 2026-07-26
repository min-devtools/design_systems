#!/usr/bin/env bash
# Bundle _min Tauri apps for Windows (sequential) and collect the installers into
# dist-windows/. Windows counterpart of bundle-macos-all.sh — it deliberately does
# NOT install anything: an .msi/-setup.exe needs elevation and user prompts, so the
# script hands you the artifacts and you run the one you want.
#
# Run from Git Bash (MSYS). Usage:
#        ./bundle-window-all.sh                    # all 6 apps
#        ./bundle-window-all.sh redis_min          # only redis_min
#        ./bundle-window-all.sh kafka_ui_min log_min
#        BUNDLES=nsis ./bundle-window-all.sh       # skip the WiX/MSI target
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ALL_APPS=(elastic_min requests_min kafka_ui_min redis_min git_min log_min)
APPS=("${@:-${ALL_APPS[@]}}")
# both installer flavours by default, matching bundle.targets "all" on macOS;
# NSIS and WiX are downloaded by tauri on first use, so the first run needs network
BUNDLES="${BUNDLES:-nsis,msi}"
OUT_DIR="$PROJECT_ROOT/dist-windows"

log() { printf '\n\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
die() { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*) ;;
  *) die "Windows + Git Bash is required (use bundle-macos-all.sh on macOS)." ;;
esac

for command in node npm cargo; do
  command -v "$command" >/dev/null || die "'$command' is required."
done

# tauri.exe is a native binary: an MSYS /tmp/... path means nothing to it
to_win_path() {
  if command -v cygpath >/dev/null; then cygpath -w "$1"; else printf '%s' "$1"; fi
}

# rdkafka compiles librdkafka and OpenSSL from source — the only app in the family
# that needs a C toolchain beyond MSVC.
needs_native_build_tools() {
  grep -qE '^[[:space:]]*(rdkafka|openssl-src)' "$1/src-tauri/Cargo.toml"
}

perl_flavour() { perl -MConfig -e 'print $Config{osname}' 2>/dev/null; }

# Prepend the native tools instead of trusting PATH: a winget install only lands in
# PATH for shells opened afterwards, and Git Bash always puts its own cygwin perl
# first — which `openssl-src`'s `perl ./Configure` rejects outright.
prepare_native_build_tools() {
  MISSING_TOOL=""
  if ! command -v cmake >/dev/null; then
    for candidate in "/c/Program Files/CMake/bin" "/c/Program Files (x86)/CMake/bin"; do
      if [ -x "$candidate/cmake.exe" ]; then PATH="$candidate:$PATH"; break; fi
    done
    command -v cmake >/dev/null || { MISSING_TOOL="cmake"; return 1; }
  fi
  if [ "$(perl_flavour)" != "MSWin32" ]; then
    for candidate in "/c/Strawberry/perl/bin" "${USERPROFILE:-}/scoop/apps/strawberry-perl/current/perl/bin"; do
      if [ -x "$candidate/perl.exe" ]; then PATH="$candidate:$PATH"; break; fi
    done
    [ "$(perl_flavour)" = "MSWin32" ] || { MISSING_TOOL="a Windows-native perl"; return 1; }
  fi
}

mkdir -p "$OUT_DIR"
START=$(date +%s)
FAILED=()
BUILT=()

for app in "${APPS[@]}"; do
  dir="$PROJECT_ROOT/$app"
  log "=== $app: start ==="

  if [ ! -d "$dir" ]; then
    log "!!! $app: directory not found, skipping"
    FAILED+=("$app (missing dir)")
    continue
  fi
  if [ ! -f "$dir/src-tauri/icons/icon.ico" ]; then
    log "!!! $app: src-tauri/icons/icon.ico missing — both installers need it"
    FAILED+=("$app (no icon.ico)")
    continue
  fi
  if [ ! -f "$dir/VERSION" ]; then
    log "!!! $app: VERSION file missing — nothing to stamp the bundle with"
    FAILED+=("$app (no VERSION)")
    continue
  fi
  if needs_native_build_tools "$dir" && ! prepare_native_build_tools; then
    log "!!! $app: needs $MISSING_TOOL on PATH (it builds librdkafka + OpenSSL from source)"
    log "    winget install Kitware.CMake StrawberryPerl.StrawberryPerl, then reopen this shell"
    FAILED+=("$app (missing $MISSING_TOOL)")
    continue
  fi

  [ -d "$dir/node_modules" ] || (cd "$dir" && npm ci)

  # Per-app release version — single source of truth, also injected into the footer
  # by vite. Passed as a file, not inline JSON: quotes get eaten crossing Git Bash →
  # npm.cmd → tauri.exe.
  VERSION="$(tr -d '[:space:]' < "$dir/VERSION")"
  version_cfg="$dir/.tauri-version.json"
  printf '{"version":"%s"}\n' "$VERSION" > "$version_cfg"
  # shellcheck disable=SC2064
  trap "rm -f '$version_cfg'" EXIT

  app_start=$(date +%s)
  log "$app: npm run tauri build --bundles $BUNDLES (v$VERSION)"
  if ! (cd "$dir" && npm run tauri build -- --bundles "$BUNDLES" --config "$(to_win_path "$version_cfg")"); then
    log "!!! $app: build FAILED, continuing with next app"
    FAILED+=("$app (build failed)")
    rm -f "$version_cfg"
    continue
  fi
  rm -f "$version_cfg"

  # -newermt guards against reporting a stale installer from an earlier run as fresh
  bundle_root="$dir/src-tauri/target/release/bundle"
  mapfile -t artifacts < <(find "$bundle_root" -maxdepth 2 -type f \
    \( -name '*.msi' -o -name '*-setup.exe' \) -newermt "@$app_start" 2>/dev/null || true)

  if [ ${#artifacts[@]} -eq 0 ]; then
    log "!!! $app: build reported success but produced no installer under $bundle_root"
    FAILED+=("$app (no installer)")
    continue
  fi

  for artifact in "${artifacts[@]}"; do
    name=$(basename "$artifact")
    cp -f "$artifact" "$OUT_DIR/$name"
    log "$app: $name -> dist-windows/"
    BUILT+=("$name")
  done
done

trap - EXIT
ELAPSED=$(( $(date +%s) - START ))
log "=== All done in ${ELAPSED}s ==="
if [ ${#BUILT[@]} -gt 0 ]; then
  printf '\nInstallers in %s:\n' "$OUT_DIR"
  (cd "$OUT_DIR" && ls -1sh "${BUILT[@]}")
  printf '\nInstall one by running it, e.g.:\n  start "" "%s"\n' "$(to_win_path "$OUT_DIR/${BUILT[0]}")"
fi
if [ ${#FAILED[@]} -gt 0 ]; then
  log "FAILED: ${FAILED[*]}"
  exit 1
fi
log "OK: ${APPS[*]}"
