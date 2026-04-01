#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INPUT_DIR="$ROOT_DIR/input/commits"
OUT_DIR="$ROOT_DIR/out"

LAB_USER_NAME=""
LAB_USER_EMAIL=""
LAB_SVN_USER=""
EXPECTED_COMMITS=15

red() {
    LAB_USER_NAME="red"
    LAB_USER_EMAIL="red@example.com"
    LAB_SVN_USER="red"
}

blue() {
    LAB_USER_NAME="blue"
    LAB_USER_EMAIL="blue@example.com"
    LAB_SVN_USER="blue"
}

load_red_identity() {
    red
    git config user.name "$LAB_USER_NAME"
    git config user.email "$LAB_USER_EMAIL"
}

load_blue_identity() {
    blue
    git config user.name "$LAB_USER_NAME"
    git config user.email "$LAB_USER_EMAIL"
}

extract_snapshot() {
    local revision="$1"
    local destination="$2"
    unzip -qq "$INPUT_DIR/commit${revision}.zip" -d "$destination"
}

git_apply_snapshot() {
    local revision="$1"
    local temp_snapshot

    temp_snapshot="$(mktemp -d)"
    extract_snapshot "$revision" "$temp_snapshot"
    find "$PWD" -mindepth 1 -maxdepth 1 \
        ! -name '.git' \
        ! -name '.svn' \
        -exec rm -rf -- {} +
    cp -a "$temp_snapshot"/. "$PWD"/
    rm -rf "$temp_snapshot"
    git add -A
}

svn_apply_snapshot() {
    local revision="$1"
    local temp_snapshot
    local entry

    temp_snapshot="$(mktemp -d)"
    extract_snapshot "$revision" "$temp_snapshot"
    for entry in ./* ./.[!.]*; do
        [[ ! -e "$entry" ]] && continue
        [[ "$entry" == "./.svn" ]] && continue

        if svn info "$entry" >/dev/null 2>&1; then
            svn rm --quiet --force "$entry" >/dev/null
        else
            rm -rf -- "$entry"
        fi
    done
    cp -a "$temp_snapshot"/. .
    rm -rf "$temp_snapshot"
    svn add --force . >/dev/null
}
