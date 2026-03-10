#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/daemonize.sh"
TARGET="/usr/local/bin/daemonize"

if [[ ! -f "$SOURCE" ]]; then
    echo "Error: daemonize.sh script not found in $SCRIPT_DIR"
    exit 1
fi

sudo cp "$SOURCE" "$TARGET"
sudo chmod +x "$TARGET"

echo "Installed daemonize to $TARGET"
