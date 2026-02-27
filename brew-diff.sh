#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRACKED_BREWFILE="$ROOT_DIR/Brewfile"
SHOW_FULL_DIFF="false"
INCLUDE_DEPS="false"

for arg in "$@"; do
  case "$arg" in
    --full-diff)
      SHOW_FULL_DIFF="true"
      ;;
    --include-deps)
      INCLUDE_DEPS="true"
      ;;
    -*)
      echo "Unknown option: $arg" >&2
      echo "Usage: $0 [Brewfile] [--full-diff] [--include-deps]" >&2
      exit 1
      ;;
    *)
      TRACKED_BREWFILE="$arg"
      ;;
  esac
done

if ! command -v brew >/dev/null 2>&1; then
  echo "brew is not installed or not in PATH." >&2
  exit 1
fi

if [[ ! -f "$TRACKED_BREWFILE" ]]; then
  echo "Brewfile not found: $TRACKED_BREWFILE" >&2
  exit 1
fi

TMP_DUMP="$(mktemp "${TMPDIR:-/tmp}/brewfile.current.XXXXXX")"
TMP_EXPECTED="$(mktemp "${TMPDIR:-/tmp}/brewfile.expected.XXXXXX")"
TMP_ACTUAL="$(mktemp "${TMPDIR:-/tmp}/brewfile.actual.XXXXXX")"
TMP_REQUESTED_FORMULAE="$(mktemp "${TMPDIR:-/tmp}/brew.requested.XXXXXX")"
TMP_ACTUAL_FILTERED="$(mktemp "${TMPDIR:-/tmp}/brewfile.actual.filtered.XXXXXX")"

cleanup() {
  rm -f "$TMP_DUMP" "$TMP_EXPECTED" "$TMP_ACTUAL" "$TMP_REQUESTED_FORMULAE" "$TMP_ACTUAL_FILTERED"
}
trap cleanup EXIT

normalize_brewfile() {
  local file="$1"
  # Keep only bundle-managed entries; ignore comments/blank lines/order.
  sed -E 's/[[:space:]]+#.*$//' "$file" \
    | rg -N '^(tap|brew|cask|mas|whalebrew|vscode)[[:space:]]+"[^"]+"' \
    | LC_ALL=C sort -u
}

collect_requested_formulae() {
  # Leaves are formulae that are not currently installed only as dependencies.
  if brew leaves 2>/dev/null | LC_ALL=C sort -u >"$TMP_REQUESTED_FORMULAE"; then
    return 0
  fi

  return 1
}

filter_dependency_formulae() {
  if [[ "$INCLUDE_DEPS" == "true" ]]; then
    cp "$TMP_ACTUAL" "$TMP_ACTUAL_FILTERED"
    return 0
  fi

  if ! collect_requested_formulae; then
    echo "Warning: could not resolve explicitly requested formulae; including dependency formulae." >&2
    cp "$TMP_ACTUAL" "$TMP_ACTUAL_FILTERED"
    return 0
  fi

  awk -v requested_file="$TMP_REQUESTED_FORMULAE" '
    BEGIN {
      while ((getline line < requested_file) > 0) {
        requested[line] = 1
      }
      close(requested_file)
    }
    /^brew "/ {
      formula = $0
      sub(/^brew "/, "", formula)
      sub(/".*$/, "", formula)
      if (formula in requested) {
        print $0
      }
      next
    }
    { print $0 }
  ' "$TMP_ACTUAL" | LC_ALL=C sort -u >"$TMP_ACTUAL_FILTERED"
}

if ! brew bundle dump --force --file="$TMP_DUMP" >/dev/null 2>&1; then
  echo "Failed to generate installed Brew snapshot with 'brew bundle dump'." >&2
  echo "Run 'brew doctor' and resolve Homebrew permission/health issues, then retry." >&2
  exit 1
fi

normalize_brewfile "$TRACKED_BREWFILE" >"$TMP_EXPECTED"
normalize_brewfile "$TMP_DUMP" >"$TMP_ACTUAL"
filter_dependency_formulae

ONLY_TRACKED="$(comm -23 "$TMP_EXPECTED" "$TMP_ACTUAL_FILTERED" || true)"
ONLY_INSTALLED="$(comm -13 "$TMP_EXPECTED" "$TMP_ACTUAL_FILTERED" || true)"

if [[ -z "$ONLY_TRACKED" && -z "$ONLY_INSTALLED" ]]; then
  echo "No dependency drift: tracked Brewfile matches installed Homebrew bundle entries."
  exit 0
fi

echo "Dependency drift found."
echo ""
echo "In tracked Brewfile but not installed on this machine:"
if [[ -n "$ONLY_TRACKED" ]]; then
  printf '%s\n' "$ONLY_TRACKED" | sed 's/^/  - /'
else
  echo "  - None"
fi

echo ""
echo "Installed on this machine but not tracked in Brewfile:"
if [[ -n "$ONLY_INSTALLED" ]]; then
  printf '%s\n' "$ONLY_INSTALLED" | sed 's/^/  - /'
else
  echo "  - None"
fi

if [[ "$SHOW_FULL_DIFF" == "true" ]]; then
  echo ""
  echo "Raw unified diff (tracked vs generated, includes deps):"
  diff -u "$TRACKED_BREWFILE" "$TMP_DUMP" || true
fi
