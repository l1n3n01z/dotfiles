#!/usr/bin/env bash

# 1. Gather your metrics
CLOCK=$(date +"%H:%M")
# CLOCK_DATE=$(date +"%a %Y-%m-%d")
CLOCK_DATE=$(date +"%a %d/%m")
# 1.1 pomodoro time!
# format
## Time
# %r  - Time remaining in mm:ss
# %R  - Time remaining in minutes, rounded
# %!r - Same as %r, but with an exclamation point if the Pomodoro is done
# %!R - Same as %R, but with an exclamation point if the Pomodoro is done
# %l  - Length of the Pomodoro in mm:ss
# %L  - Length of the Pomodoro in minutes
#
# # Metadata
# %d  - Pomodoro description
# %t  - Pomodoro tags, joined by a comma
#
# # Goals
# %g  - Daily Pomodoro goal
# %!g  - Daily Pomodoro goal, with a preceding slash
# %c  - Completed Pomodoros today
POMO_RAW=$(pomodoro status -f '%r:%d')

#2. Figure out the pomodoro color logic in pure bash
POMO_BAR=""
if [[ "$POMO_RAW" =~ ^0:00:.* ]]; then
  POMO_BAR="DONE"
  POMO_BG="colour1" # Red when done
else
  POMO_BG="colour2" # Green
  # Convert "mm:ss" to total seconds remaining
  IFS=: read -r mins secs pomostatus <<<"$POMO_RAW"
  # IFS=: read -r mins secs pomostatus <<<"$POMO_RAW"
  TOTAL_SECS=$(((10#$mins * 60) + 10#$secs))

  # Calculate full 5-minute blocks remaining (max 5 blocks for 25 mins)
  FULL_BLOCKS=$((TOTAL_SECS / 300))

  # Calculate the remainder seconds of the current active 5-minute block
  REMAINDER_SECS=$((TOTAL_SECS % 300))

  # Build the lifebar starting with the solid blocks
  for ((i = 0; i < FULL_BLOCKS; i++)); do
    POMO_BAR="${POMO_BAR}●"
  done

  # Append the pie chart icon for the fractional block if time remains
  if [ $TOTAL_SECS -gt 0 ] && [ $FULL_BLOCKS -lt 5 ]; then
    if [ $REMAINDER_SECS -ge 225 ]; then
      POMO_BAR="${POMO_BAR}●" # 75-100% of the block left
    elif [ $REMAINDER_SECS -ge 150 ]; then
      POMO_BAR="${POMO_BAR}◔" # 50-75% of the block left
    elif [ $REMAINDER_SECS -ge 75 ]; then
      POMO_BAR="${POMO_BAR}◑" # 25-50% of the block left
    else
      POMO_BAR="${POMO_BAR}◕" # 0-25% of the block left
    fi
  fi

  # Pad the rest of the bar with empty space or dots to keep length consistent (5 characters total)
  while [ ${#POMO_BAR} -lt 5 ]; do
    POMO_BAR="${POMO_BAR}○"
  done
  POMO_BAR="$pomostatus ${POMO_BAR}"
fi

#colors
dark_gray="colour237"
mid_gray="colour239"
light_gray="colour246"

#prints the filled arrow to transit nicely between background colours
transition_arrow() {
  start_bg="$1"
  end_bg="$2"
  end_fg="$3"
  echo "#[bg=${start_bg},fg=${end_bg}]#[bg=${end_bg},fg=${end_fg}]"
}

# 3. Print the final string using your exact theme layout and glyphs
# echo "$(transition_arrow $dark_gray $mid_gray $light_gray) ${COPILOT}  ${CLOCK_DATE}  ${CLOCK} $(transition_arrow $mid_gray ${POMO_BG} $mid_gray) ${POMO_BAR} $(transition_arrow ${POMO_BG} colour248 colour37) #h "
echo "$(transition_arrow $dark_gray $mid_gray $light_gray) ${CLOCK_DATE} | ${CLOCK} $(transition_arrow $mid_gray ${POMO_BG} $mid_gray) ${POMO_BAR} $(transition_arrow ${POMO_BG} colour248 colour37) #h "
