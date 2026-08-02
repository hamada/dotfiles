#!/bin/bash
# Converted from ~/.zshrc PROMPT:
#   PROMPT=%F{green}%d$'\n''$ '%f
# (green current directory; trailing "$ " prompt marker dropped per statusline conventions)
input=$(cat) #  stdin の JSON を読む

DIR=$(echo "$input" | jq -r '.workspace.current_dir')
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
PCT_INT=$(printf '%.0f' "$PCT")

BRANCH=$(git --no-optional-locks -C "$DIR" branch --show-current 2>/dev/null)
if [ -z "$BRANCH" ]; then
  BRANCH=$(git --no-optional-locks -C "$DIR" rev-parse --short HEAD 2>/dev/null)
fi
[ -n "$BRANCH" ] && BRANCH_SEG="\033[36m${BRANCH}\033[0m | " || BRANCH_SEG=""

BAR_WIDTH=10
FILLED=$(( PCT_INT * BAR_WIDTH / 100 ))
[ "$FILLED" -gt "$BAR_WIDTH" ] && FILLED=$BAR_WIDTH
EMPTY=$(( BAR_WIDTH - FILLED ))

BAR=""
for ((i = 0; i < FILLED; i++)); do BAR+="█"; done
for ((i = 0; i < EMPTY; i++)); do BAR+="░"; done

if [ "$PCT_INT" -ge 80 ]; then
  BAR_COLOR='\033[31m' # red
elif [ "$PCT_INT" -ge 50 ]; then
  BAR_COLOR='\033[33m' # yellow
else
  BAR_COLOR='\033[32m' # green
fi

printf '\033[32m%s\033[0m\n%b%s | %b[%s]\033[0m %d%%\n' "$DIR" "$BRANCH_SEG" "$MODEL" "$BAR_COLOR" "$BAR" "$PCT_INT"
