#!/usr/bin/env bash
#
# create-and-push.sh
#
# gh CLI로 각 코드랩(독립 git 저장소)의 GitHub 원격을 생성하고 push한 뒤,
# 루트에서 submodule로 연결한다. 루트 저장소도 생성·push한다.
#
# 사전:
#   - gh 설치 + `gh auth login` 완료 (브라우저 인증)
#   - 각 코드랩 폴더는 이미 git init + commit 되어 있음
#
# 사용:
#   GITHUB_USER=your-id VISIBILITY=public ./scripts/create-and-push.sh

set -euo pipefail

GITHUB_USER="${GITHUB_USER:-$(gh api user -q .login)}"
VISIBILITY="${VISIBILITY:-public}"   # public | private
ROOT_REPO="${ROOT_REPO:-flutter_codelab}"

MODULES=(
  week01_dart_basics
  week02_widgets_layout
  week03_input_list_nav
  week04_bloc_intro
  week05_clean_architecture
  week06_di_repository_local
  mindnote
)

cd "$(dirname "$0")/.."   # 루트로 이동

echo "▶ user=${GITHUB_USER}  visibility=${VISIBILITY}"

# 1) 각 코드랩: 원격 생성 + push
for name in "${MODULES[@]}"; do
  echo "── $name"
  if gh repo view "${GITHUB_USER}/${name}" >/dev/null 2>&1; then
    echo "   원격이 이미 있음 → push만"
    git -C "$name" remote remove origin 2>/dev/null || true
    git -C "$name" remote add origin "https://github.com/${GITHUB_USER}/${name}.git"
    git -C "$name" push -u origin main
  else
    gh repo create "${GITHUB_USER}/${name}" \
      "--${VISIBILITY}" --source "$name" --remote origin --push
  fi
done

# 2) 루트에서 submodule 연결 (.gitignore 무시 중이면 -f)
for name in "${MODULES[@]}"; do
  rm -rf "$name"
  git submodule add -f "https://github.com/${GITHUB_USER}/${name}.git" "$name"
done
git submodule update --init --recursive
git add .gitmodules "${MODULES[@]}"
git commit -m "Add codelab chapters as git submodules

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"

# 3) 루트 저장소 생성 + push
if gh repo view "${GITHUB_USER}/${ROOT_REPO}" >/dev/null 2>&1; then
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/${GITHUB_USER}/${ROOT_REPO}.git"
  git push -u origin main
else
  gh repo create "${GITHUB_USER}/${ROOT_REPO}" \
    "--${VISIBILITY}" --source . --remote origin --push
fi

echo "✔ 완료. 루트: https://github.com/${GITHUB_USER}/${ROOT_REPO}"
