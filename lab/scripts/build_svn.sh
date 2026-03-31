#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

SVN_ROOT_DIR="$OUT_DIR/svn"
SVN_REPO_DIR="$SVN_ROOT_DIR/repo"
SVN_WC_DIR="$SVN_ROOT_DIR/wc"

rm -rf "$SVN_ROOT_DIR"
mkdir -p "$SVN_ROOT_DIR"

svnadmin create "$SVN_REPO_DIR"
REPO_URL="file://$SVN_REPO_DIR"

red
svn mkdir "$REPO_URL/trunk" "$REPO_URL/branches" -m "Init repository layout" --username "$LAB_SVN_USER" >/dev/null
svn checkout "$REPO_URL/trunk" "$SVN_WC_DIR" >/dev/null
cd "$SVN_WC_DIR"

red
svn_apply_snapshot 0
svn commit -m "r0" --username "$LAB_SVN_USER" >/dev/null

svn copy "$REPO_URL/trunk" "$REPO_URL/branches/red-bottom" -m "Create red-bottom branch" --username "$LAB_SVN_USER" >/dev/null
svn switch "$REPO_URL/branches/red-bottom" >/dev/null
red
svn_apply_snapshot 1
svn commit -m "r1" --username "$LAB_SVN_USER" >/dev/null

svn switch "$REPO_URL/trunk" >/dev/null
red
svn_apply_snapshot 2
svn commit -m "r2" --username "$LAB_SVN_USER" >/dev/null

svn copy "$REPO_URL/trunk" "$REPO_URL/branches/blue" -m "Create blue branch" --username "$LAB_SVN_USER" >/dev/null
svn switch "$REPO_URL/branches/blue" >/dev/null
blue
svn_apply_snapshot 3
svn commit -m "r3" --username "$LAB_SVN_USER" >/dev/null
svn_apply_snapshot 4
svn commit -m "r4" --username "$LAB_SVN_USER" >/dev/null
svn_apply_snapshot 5
svn commit -m "r5" --username "$LAB_SVN_USER" >/dev/null
svn_apply_snapshot 6
svn commit -m "r6" --username "$LAB_SVN_USER" >/dev/null

svn switch "$REPO_URL/trunk" >/dev/null
red
svn_apply_snapshot 7
svn commit -m "r7" --username "$LAB_SVN_USER" >/dev/null

svn switch "$REPO_URL/branches/red-bottom" >/dev/null
red
svn_apply_snapshot 8
svn commit -m "r8" --username "$LAB_SVN_USER" >/dev/null
svn_apply_snapshot 9
svn commit -m "r9" --username "$LAB_SVN_USER" >/dev/null

svn switch "$REPO_URL/branches/blue" >/dev/null
blue
svn_apply_snapshot 10
svn commit -m "r10" --username "$LAB_SVN_USER" >/dev/null
svn_apply_snapshot 11
svn commit -m "r11" --username "$LAB_SVN_USER" >/dev/null

svn switch "$REPO_URL/branches/red-bottom" >/dev/null
red
# Конфликты оставляем в рабочей копии, затем приводим файлы к нужному снимку.
svn merge "$REPO_URL/branches/blue" --accept postpone >/dev/null 2>&1 || true
svn_resolve_working_copy
svn_apply_snapshot 12
svn_resolve_working_copy
svn commit -m "r12" --username "$LAB_SVN_USER" >/dev/null

svn switch "$REPO_URL/trunk" >/dev/null
red
# Повторяем ту же схему для слияния ветки red-bottom в trunk.
svn merge "$REPO_URL/branches/red-bottom" --accept postpone >/dev/null 2>&1 || true
svn_resolve_working_copy
svn_apply_snapshot 13
svn_resolve_working_copy
svn commit -m "r13" --username "$LAB_SVN_USER" >/dev/null

svn_apply_snapshot 14
svn commit -m "r14" --username "$LAB_SVN_USER" >/dev/null

svn log "$REPO_URL" -q > "$SVN_ROOT_DIR/log.txt"
