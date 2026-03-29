#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INPUT_DIR="$ROOT_DIR/input/commits"
OUT_DIR="$ROOT_DIR/out"

LAB_USER_NAME=""
LAB_USER_EMAIL=""
LAB_SVN_USER=""

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

clear_plain_dir() {
    local target="$1"

    find "$target" -mindepth 1 -maxdepth 1 \
        ! -name '.git' \
        ! -name '.svn' \
        -exec rm -rf -- {} +
}

apply_snapshot_to_dir() {
    local revision="$1"
    local target="$2"
    local tmp_dir

    tmp_dir="$(mktemp -d)"
    unzip -qq -o "$INPUT_DIR/commit${revision}.zip" -d "$tmp_dir"
    clear_plain_dir "$target"
    cp -a "$tmp_dir"/. "$target"/
    rm -rf "$tmp_dir"
}

git_apply_snapshot() {
    local revision="$1"

    apply_snapshot_to_dir "$revision" "$PWD"
    git add -A
}

clear_svn_wc() {
    find . -mindepth 1 -maxdepth 1 ! -name '.svn' -print0 | while IFS= read -r -d '' entry; do
        if svn info "$entry" >/dev/null 2>&1; then
            svn rm --quiet --force "$entry" >/dev/null
        else
            rm -rf -- "$entry"
        fi
    done
}

svn_apply_snapshot() {
    local revision="$1"
    local tmp_dir

    tmp_dir="$(mktemp -d)"
    unzip -qq -o "$INPUT_DIR/commit${revision}.zip" -d "$tmp_dir"
    clear_svn_wc
    cp -a "$tmp_dir"/. .
    rm -rf "$tmp_dir"
    svn add --force . >/dev/null
}

svn_resolve_working_copy() {
    svn resolve --accept working -R . >/dev/null 2>&1 || true
}
