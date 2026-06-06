#!/bin/bash
HYPRIDLE_LOCK_FILE="/tmp/hypridle.lock"

if [ -f "$HYPRIDLE_LOCK_FILE" ]; then
  rm "$HYPRIDLE_LOCK_FILE"
else
  touch "$HYPRIDLE_LOCK_FILE"
fi
