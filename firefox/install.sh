#!/bin/sh
set -e

PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles/9bv2k615.default-release"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$PROFILE_DIR" ]; then
	echo "профиль не найден: $PROFILE_DIR" >&2
	echo "поправь путь в install.sh" >&2
	exit 1
fi

ln -sf "$SCRIPT_DIR/user.js" "$PROFILE_DIR/user.js"
echo "user.js -> $PROFILE_DIR/user.js"
