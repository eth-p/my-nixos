#!/usr/bin/env bash
set -euo pipefail

debounced_pid=
debounce() {
  if [[ -n "$debounced_pid" ]]; then
    kill -USR1 "$debounced_pid" || true
    debounced_pid=''
  fi

  # Create a pipe to ensure the trap is set.
  ready_signal="$(mktemp)"
  rm "$ready_signal"
  mkfifo "$ready_signal"

  # Spawn a background process that will wait before acting.
  (
    trap 'echo "[X] Debounced"; exit 0' USR1
    echo READY >"$ready_signal"
    sleep "$1"
    echo "[X] Triggered"
    "${@:2}" || return $?
  ) &
  debounced_pid="$!"

  # Wait for the subprocess' trap to be set.
  read -r <"$ready_signal"
  rm "$ready_signal"
}

# Turn LEDs on/off depending on lock screen status.
dbus-monitor --session "type='signal',interface='org.freedesktop.ScreenSaver'" |
  while read x; do
    case "$x" in 
      *"boolean true"*) debounce 1 openrgb --profile Off;;
      *"boolean false"*) debounce 1 openrgb --profile Default;;  
    esac
  done
