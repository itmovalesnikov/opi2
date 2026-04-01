#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

GIT_REPO_DIR="$OUT_DIR/git-repo"

rm -rf "$GIT_REPO_DIR"
mkdir -p "$OUT_DIR"

git init -b master "$GIT_REPO_DIR" >/dev/null
cd "$GIT_REPO_DIR"

git config commit.gpgsign false

load_red_identity
git_apply_snapshot 0
git commit -m "r0" >/dev/null

git checkout -b red-bottom >/dev/null
load_red_identity
git_apply_snapshot 1
git commit -m "r1" >/dev/null

git checkout master >/dev/null
load_red_identity
git_apply_snapshot 2
git commit -m "r2" >/dev/null

git checkout -b blue >/dev/null
load_blue_identity
git_apply_snapshot 3
git commit -m "r3" >/dev/null
git_apply_snapshot 4
git commit -m "r4" >/dev/null
git_apply_snapshot 5
git commit -m "r5" >/dev/null
git_apply_snapshot 6
git commit -m "r6" >/dev/null

git checkout master >/dev/null
load_red_identity
git_apply_snapshot 7
git commit -m "r7" >/dev/null

git checkout red-bottom >/dev/null
load_red_identity
git_apply_snapshot 8
git commit -m "r8" >/dev/null
git_apply_snapshot 9
git commit -m "r9" >/dev/null

git checkout blue >/dev/null
load_blue_identity
git_apply_snapshot 10
git commit -m "r10" >/dev/null
git_apply_snapshot 11
git commit -m "r11" >/dev/null

git checkout red-bottom >/dev/null
load_red_identity
git merge --no-ff --no-commit blue >/dev/null 2>&1 || true
git_apply_snapshot 12
git commit -m "r12" >/dev/null

git checkout master >/dev/null
load_red_identity
git merge --no-ff --no-commit red-bottom >/dev/null 2>&1 || true
git_apply_snapshot 13
git commit -m "r13" >/dev/null

git_apply_snapshot 14
git commit -m "r14" >/dev/null

git log --graph --decorate --oneline --all > "$OUT_DIR/git-graph.txt"
