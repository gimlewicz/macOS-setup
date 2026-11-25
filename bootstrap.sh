#!/usr/bin/env bash
# Bootstrap a Mac: install Homebrew, the Brewfile, and oh-my-zsh.
# Safe to re-run; each step skips work that is already done.
#
# Written for the bash 3.2 that ships with macOS (no associative arrays etc.).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_DIR/Brewfile"

log()  { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mWarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

require_macos() {
  [ "$(uname -s)" = "Darwin" ] || die "This script only supports macOS."
}

# --- Homebrew ---------------------------------------------------------------
# Print the path to brew, checking the default prefixes for Apple Silicon and
# Intel so it is found even before brew is on PATH.
find_brew() {
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done
  command -v brew 2>/dev/null
}

install_homebrew() {
  local brew
  if brew="$(find_brew)"; then
    log "Homebrew already installed at $brew"
    return
  fi
  log "Installing Homebrew"
  # NONINTERACTIVE=1 makes the official installer skip its prompts.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Put brew on PATH for login and interactive shells, zsh and bash alike.
# Runs after oh-my-zsh, because its installer replaces ~/.zshrc.
persist_shellenv() {
  local brew="$1"
  local line="eval \"\$($brew shellenv)\""
  local profile
  for profile in "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.bashrc"; do
    if ! grep -qsF "$line" "$profile"; then
      printf '\n# Homebrew\n%s\n' "$line" >> "$profile"
      log "Added Homebrew shellenv to $profile"
    fi
  done
}

# --- Brewfile ---------------------------------------------------------------
install_bundle() {
  log "Installing packages from $BREWFILE"
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_BUNDLE_NO_LOCK=1
  brew update
  brew bundle install --file="$BREWFILE" --verbose
}

# --- oh-my-zsh --------------------------------------------------------------
install_oh_my_zsh() {
  if [ -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    log "oh-my-zsh already installed"
    return
  fi
  log "Installing oh-my-zsh"
  # --unattended: don't chsh and don't drop into a new zsh at the end.
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

main() {
  require_macos
  install_homebrew

  local brew
  brew="$(find_brew)" || die "Homebrew install failed: brew not found"
  eval "$("$brew" shellenv)"

  install_bundle
  install_oh_my_zsh
  persist_shellenv "$brew"
  log "Done. Open a new terminal (or iTerm2) to pick up the changes."
}

main "$@"
