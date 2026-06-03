#!/usr/bin/env bash

log_info()  { echo "[INFO]  $(date '+%H:%M:%S') $*"; }
log_warn()  { echo "[WARN]  $(date '+%H:%M:%S') $*" >&2; }
log_error() { echo "[ERROR] $(date '+%H:%M:%S') $*" >&2; }

read_first_non_empty_line() {
  local file="$1"
  awk 'NF { gsub(/\r$/, "", $0); print; exit }' "$file"
}
