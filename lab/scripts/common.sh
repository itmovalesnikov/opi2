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

set_git_user() {
    git config user.name "$LAB_USER_NAME"
    git config user.email "$LAB_USER_EMAIL"
}

load_red_identity() {
    red
    set_git_user
}

load_blue_identity() {
    blue
    set_git_user
}

clear_plain_dir() {
    local target="$1"

    find "$target" -mindepth 1 -maxdepth 1 \
        ! -name '.git' \
        ! -name '.svn' \
        -exec rm -rf -- {} +
}

extract_snapshot() {
    local revision="$1"
    local destination="$2"
    unzip -qq "$INPUT_DIR/commit${revision}.zip" -d "$destination"
}

replace_dir_with_snapshot() {
    local revision="$1"
    local target="$2"
    local temp_snapshot

    temp_snapshot="$(mktemp -d)"
    extract_snapshot "$revision" "$temp_snapshot"
    clear_plain_dir "$target"
    cp -a "$temp_snapshot"/. "$target"/
    rm -rf "$temp_snapshot"
}

git_apply_snapshot() {
    local revision="$1"

    replace_dir_with_snapshot "$revision" "$PWD"
    git add -A
}

clean_svn_working_copy() {
    local entry

    for entry in ./* ./.[!.]*; do
        [[ ! -e "$entry" ]] && continue
        [[ "$entry" == "./.svn" ]] && continue

        if svn info "$entry" >/dev/null 2>&1; then
            svn rm --quiet --force "$entry" >/dev/null
        else
            rm -rf -- "$entry"
        fi
    done
}

svn_apply_snapshot() {
    local revision="$1"
    local temp_snapshot

    temp_snapshot="$(mktemp -d)"
    extract_snapshot "$revision" "$temp_snapshot"
    clean_svn_working_copy
    cp -a "$temp_snapshot"/. .
    rm -rf "$temp_snapshot"
    svn add --force . >/dev/null
}
