#!/usr/bin/env bash
# Start a project from a skeleton:  new.sh module|root|terragrunt <target-dir>
#
# `tofu init -from-module` skips dotfiles, so .gitignore and .tflint.hcl would
# be lost; this copies them too. Works from a clone; for a remote-only start
# use -from-module and fetch the two dotfiles by hand.
set -euo pipefail
kind=${1:?usage: new.sh module|root|terragrunt <target-dir>}
target=${2:?usage: new.sh module|root|terragrunt <target-dir>}
src="$(cd "$(dirname "$0")" && pwd)/$kind"
[ -d "$src" ] || { echo "unknown skeleton: $kind" >&2; exit 1; }
mkdir -p "$target"
[ -z "$(ls -A "$target")" ] || { echo "$target is not empty" >&2; exit 1; }

case "$kind" in
  module) (cd "$target" && tofu init -from-module="$src") ;;
  root)   (cd "$target" && tofu init -from-module="$src" -backend=false) ;;
  terragrunt) cp -r "$src/." "$target/" ;;
esac
for f in .gitignore .tflint.hcl; do
  [ -f "$src/$f" ] && [ ! -e "$target/$f" ] && cp "$src/$f" "$target/$f"
done
echo "created $kind in $target"
