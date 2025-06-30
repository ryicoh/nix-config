#!/bin/bash
# git rebase -i用のGIT_SEQUENCE_EDITOR
#
# 普通のvim(GIT_SEQUENCE_EDITOR未設定時)との違い:
#   通常のgit rebase -iでメッセージを書き換えたい場合、
#     1. todoで該当行を`pick`→`reword`に変更
#     2. 保存して閉じる
#     3. コミットごとにエディタが再度開いてメッセージを編集
#     4. 保存して閉じる(対象コミットの数だけ繰り返し)
#   と多段階の操作が必要。
#
#   このeditorはtodo編集の1ステップで完結できる:
#     todoの各pick行は元から`pick <hash> # <subject>`形式で開かれるので、
#     ` # `以降のsubject部分をそのまま書き換えて保存するだけ。
#     書き換えた行は裏で`exec git commit --amend`に展開され、自動反映される。
#
# 使い方:
#   通常通り`git rebase -i <base>`を実行 → todoが開く。各行は
#     pick abc1234 # ORIGINAL_SUBJECT
#   の形式。書き換えたい行の` # `以降を新しいsubjectに編集:
#     pick abc1234 # feat: NEW_SUBJECT
#   保存・終了で反映。編集していない行(元subjectのまま)はamendされず、
#   通常のpickとして処理される。
#
# 仕様:
#   - 区切りは最後の` # `(subject内に` # `があっても末尾を優先)
#   - もとのコミットが複数行(本文あり)の場合: 1行目だけ書き換え、本文は保持
#     (本文保持のため一時fileを使い、rebase完了後に`exec rm -rf`で掃除)
#   - 単一行コミットの場合:`git commit --amend -m "..."`を直接emit

set -euo pipefail
TODO="$1"

"${EDITOR:-vim}" "$TODO"

OUT="$(mktemp)"
MSGDIR=""
cleanup() { rm -f "$OUT"; }
trap cleanup EXIT

while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ "$line" =~ ^(pick|p|reword|r)[[:space:]]+([a-fA-F0-9]+)[[:space:]] ]] && [[ "$line" == *" # "* ]]; then
    hash="${BASH_REMATCH[2]}"

    # 最後の" # "で分割(subjectに" # "が含まれるケースに対応)
    head="${line% # *}"
    newsubject="${line##* # }"

    # もとのsubjectと同じならamend不要(そのままpick)
    oldsubject=$(git log -1 --format=%s "$hash" 2>/dev/null || true)
    if [[ "$newsubject" == "$oldsubject" ]]; then
      echo "$head"
      continue
    fi

    # もとのコミットの本文(subjectを除く)を取得
    body=$(git log -1 --format=%b "$hash" 2>/dev/null || true)
    # 末尾の改行を除去
    body="${body%$'\n'}"

    echo "$head"

    if [[ -n "${body//[[:space:]]/}" ]]; then
      # 本文ありなら新subject + 元本文をfileに書いて-Fで渡す(本文保持)
      if [[ -z "$MSGDIR" ]]; then
        MSGDIR=$(mktemp -d -t git-rebase-editor)
      fi
      msgfile="$MSGDIR/$hash.msg"
      printf '%s\n\n%s\n' "$newsubject" "$body" > "$msgfile"
      echo "exec git commit --amend --allow-empty -F \"$msgfile\""
    else
      escaped="${newsubject//\"/\\\"}"
      echo "exec git commit --amend --allow-empty -m \"$escaped\""
    fi
  else
    echo "$line"
  fi
done < "$TODO" > "$OUT"

# tempメッセージfileの後始末をrebase完了後に行う
if [[ -n "$MSGDIR" ]]; then
  echo "exec rm -rf \"$MSGDIR\"" >> "$OUT"
fi

mv "$OUT" "$TODO"
trap - EXIT
