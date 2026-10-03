#!/usr/bin/env bash

set -euo pipefail

SRC="$HOME/.config"

if [ $# -lt 1 ]; then
    cat >&2 <<'EOF'
Usage: ./backup-config.sh <destination-dir> [extra rsync args...]

Copies ~/.config to <destination-dir>, skipping everything home-manager
manages (symlinks into /nix/store), since those are rebuilt from the flake.

Examples:
  ./backup-config.sh /mnt/backup/.config
  ./backup-config.sh /mnt/backup/.config --dry-run
EOF
    exit 1
fi

DEST="$1"
shift

if [ ! -d "$SRC" ]; then
    echo "Source not found: $SRC" >&2
    exit 1
fi

mkdir -p "$DEST"

EXCLUDES="$(mktemp)"
trap 'rm -f "$EXCLUDES"' EXIT

find "$SRC" -type l -lname '/nix/store/*' -printf '/%P\n' | sort >"$EXCLUDES"

echo "Skipping $(wc -l <"$EXCLUDES") home-manager symlink(s):"
sed 's|^/|  |' "$EXCLUDES"
echo

rsync -avh --exclude-from="$EXCLUDES" "$@" "$SRC/" "$DEST/"

echo
echo "Backed up $SRC -> $DEST"
