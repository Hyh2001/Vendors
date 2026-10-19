#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: get_vendors.sh [--directory PATH] [--repo URL] PACKAGE [PACKAGE ...]

Check out selected vendor packages using a shallow, partial Git clone.
Run from your ROS 2 workspace root. Defaults:
  --directory src/Vendors
  --repo      https://github.com/Hyh2001/Vendors.git

Examples:
  bash get_vendors.sh unitree_sdk_vendor
  bash get_vendors.sh placo_vendor unitree_sdk_vendor

Rerunning selects exactly the named packages. Existing checkouts must be clean.
An existing checkout keeps its current revision; use git pull to update it.
The script prints the rosdep dependency installation command without running it.
EOF
}

fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

directory=src/Vendors
repository=https://github.com/Hyh2001/Vendors.git
packages=()
while (($#)); do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --directory|--repo)
      (($# >= 2)) && [[ -n "$2" ]] || fail "$1 requires a value"
      if [[ "$1" == --directory ]]; then directory=$2; else repository=$2; fi
      shift 2
      ;;
    --*) fail "Unknown option: $1" ;;
    *)
      [[ "$1" =~ ^[a-z][a-z0-9_]*_vendor$ ]] || fail "Invalid vendor package name: $1"
      packages+=("$1")
      shift
      ;;
  esac
done
((${#packages[@]})) || { usage >&2; exit 1; }
command -v git >/dev/null || fail "Git is required"

if [[ ! -e "$directory" ]]; then
  mkdir -p -- "$(dirname -- "$directory")"
  git clone --depth 1 --filter=blob:none --sparse -- "$repository" "$directory"
fi
[[ -e "$directory/.git" ]] || fail "$directory exists but is not a Git checkout"
[[ -z "$(git -C "$directory" status --porcelain)" ]] ||
  fail "$directory has local changes; commit or stash them before selecting packages"

# Validate all names before changing the existing sparse selection.
for package in "${packages[@]}"; do
  git -C "$directory" cat-file -e "HEAD:$package/package.xml" 2>/dev/null ||
    fail "Package '$package' is not available in this checkout"
done
git -C "$directory" sparse-checkout set --cone -- "${packages[@]}"

printf '\nSelected packages in %s:\n' "$directory"
printf '  %s\n' "${packages[@]}"
printf '\nInstall dependencies from your ROS 2 workspace with ROS sourced:\n'
paths=()
for package in "${packages[@]}"; do paths+=("$directory/$package"); done
printf 'rosdep install --from-paths'
printf ' %q' "${paths[@]}"
printf ' --ignore-src -r -y\n'
