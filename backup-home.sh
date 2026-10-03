#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME"

if [ $# -lt 1 ]; then
    cat >&2 <<'EOF'
Usage: ./backup-home.sh <destination-dir> [extra rsync args...]

Copies $HOME to <destination-dir>, skipping anything home-manager owns
(symlinks into /nix/store) plus caches and nix state that rebuild themselves.

Examples:
  ./backup-home.sh /mnt/backup/listport
  ./backup-home.sh /mnt/backup/listport --dry-run
EOF
    exit 1
fi

DEST="$1"
shift

mkdir -p "$DEST"

# SSH refuses keys looser than 0600, and FAT/NTFS silently drop the mode bits.
case "$(stat -f -c %T "$DEST" 2>/dev/null || echo unknown)" in
msdos | vfat | exfat | ntfs | fuseblk)
    cat >&2 <<EOF
WARNING: $DEST looks like a FAT/NTFS filesystem, which cannot store unix
permissions. Private keys would restore world-readable and ssh would reject
them. Archive the sensitive dirs instead:

    tar czf "$DEST/keys.tar.gz" -C "$SRC" .ssh .gnupg .pki

EOF
    read -rp "Continue anyway? [y/N] " reply
    [[ $reply == [yY] ]] || exit 1
    ;;
esac

EXCLUDES="$(mktemp)"
trap 'rm -f "$EXCLUDES"' EXIT

# Regenerated on next login / rebuild, and big enough to matter.
cat >"$EXCLUDES" <<'EOF'
/.cache/
/.local/share/Trash/
/.local/share/nvim/
/.local/state/nix/
/.nix-defexpr/
/.nix-profile
/.zcompdump*
EOF

# Prune the skipped trees so the scan doesn't walk gigabytes to find nothing.
find "$SRC" \
    \( -path "$SRC/.cache" -o -path "$SRC/.local/share/nvim" \) -prune -o \
    -type l -lname '/nix/store/*' -printf '/%P\n' |
    sort >>"$EXCLUDES"

echo "Excluding $(wc -l <"$EXCLUDES") path(s) (home-manager symlinks, caches, nix state)."
echo

rsync -avh --exclude-from="$EXCLUDES" "$@" "$SRC/" "$DEST/"

cat <<EOF

Backed up $SRC -> $DEST

Still to do by hand — WiFi passwords live outside \$HOME and need root:

    sudo cp -a /etc/NetworkManager/system-connections "$DEST/nm-connections"

To restore them on the new machine:

    sudo cp -a "$DEST/nm-connections/." /etc/NetworkManager/system-connections/
    sudo chmod 600 /etc/NetworkManager/system-connections/*
EOF
