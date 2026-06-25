#!/usr/bin/env bash
#
# setup-submodules.sh
#
# 각 코드랩(독립 git 저장소)을 GitHub 등 원격에 올린 뒤,
# 루트 저장소에서 git submodule로 한 번에 연결한다.
#
# 사용 전제:
#   - 각 코드랩 폴더는 이미 git init + commit 되어 있다(이 코드랩의 기본 상태).
#   - 아래 GITHUB_USER / 저장소 이름 규칙대로 원격 저장소를 미리 만들어 둔다.
#     (예: gh repo create $GITHUB_USER/<name> --public --source <폴더> --push)
#
# 실행:
#   GITHUB_USER=your-id ./scripts/setup-submodules.sh
#   # 또는 SSH를 쓰려면:  USE_SSH=1 GITHUB_USER=your-id ./scripts/setup-submodules.sh

set -euo pipefail

GITHUB_USER="${GITHUB_USER:-SangWook16074}"
USE_SSH="${USE_SSH:-0}"

# 폴더명 == 원격 저장소명 으로 가정한다. 다르면 이 배열을 수정하라.
MODULES=(
  week01_dart_basics
  week02_widgets_layout
  week03_input_list_nav
  week04_bloc_intro
  week05_clean_architecture
  week06_di_repository_local
  mindnote
)

repo_url() {
  local name="$1"
  if [ "$USE_SSH" = "1" ]; then
    echo "git@github.com:${GITHUB_USER}/${name}.git"
  else
    echo "https://github.com/${GITHUB_USER}/${name}.git"
  fi
}

cd "$(dirname "$0")/.."   # 루트로 이동

echo "▶ 루트에서 submodule을 연결합니다 (user=${GITHUB_USER}, ssh=${USE_SSH})"

for name in "${MODULES[@]}"; do
  url="$(repo_url "$name")"

  # 1) 해당 폴더의 원격에 push (origin이 없으면 추가)
  if [ -d "$name/.git" ]; then
    echo "  • $name → push to $url"
    git -C "$name" remote remove origin 2>/dev/null || true
    git -C "$name" remote add origin "$url"
    git -C "$name" branch -M main
    git -C "$name" push -u origin main
  fi

  # 2) 루트 추적에서 폴더를 잠시 비우고 submodule로 다시 추가
  #    (.gitignore가 무시 중이면 -f로 강제)
  rm -rf "$name"
  git submodule add -f "$url" "$name"
done

git submodule update --init --recursive
echo "✔ 완료. 'git status'로 .gitmodules와 submodule 등록을 확인하세요."
