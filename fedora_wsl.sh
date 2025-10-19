#!/bin/bash

# This script is made for Fedora in WSL. These commands apply to DNF5 only

# --- START: HELPER FUNCTIONS ---
info() {
  local message="$1"
  echo "[!] $message"
}

error() {
  local message="$1"
  echo "[-] $message"
}

success() {
  local message="$1"
  echo "[+] $message"
}

install() {
  # Check if any arguments are provided
  if [ $# -eq 0 ]; then
    error "No package names provided."
    return 1
  fi

  # Print the packages being installed
  info "Installing: $*"

  # Install the packages
  if sudo dnf install -y "$@"; then
    success "Successfully installed: $*"
  else
    error "Failed to install: $*"
    return 1
  fi
}

copr_enable() {
  # Check if any arguments are provided
  if [ $# -eq 0 ]; then
    error "No package names provided."
    return 1
  fi

  # Print the packages being copr enabled
  info "Copr enabling: $*"

  # Copr enable the packages
  if sudo dnf copr enable -y "$@"; then
    success "Successfully copr enabled: $*"
  else
    error "Failed to copr enable: $*"
    return 1
  fi
}
# --- END: HELPER FUNCTIONS ---

# --- START: CREATING DIRECTORY FOR DOWNLOADING NECESSARY FILES AND UPDATING THE REPOSITORY ---
info "Creating the '/tmp/fedora-install-script/' for downloading necessary files"

# Create the directory if it doesn't exist
if [ ! -d "/tmp/fedora-install-script/" ]; then
  mkdir /tmp/fedora-install-script/
fi

# Change to the directory
cd /tmp/fedora-install-script/ || {
  echo "Failed to change directory"
  exit 1
}

info "Update the package list"
sudo dnf check-update
# --- END: CREATING DIRECTORY FOR DOWNLOADING NECESSARY FILES AND UPDATING THE REPOSITORY ---

# Name: rustup
# Description: An installer for the systems programming language Rust
# Website: https://rustup.rs/
# Github Repository:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# --- START: GIT AND GITHUB RELATED STUFF ---
# Name: Github CLI
# Description: GitHub’s official command line tool
# Website: https://cli.github.com/
# Github Repository: https://github.com/cli/cli
install dnf5-plugins
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
install gh --repo gh-cli

# Name: Delta
# Description: A syntax-highlighting pager for git, diff, and grep output
# Website: https://dandavison.github.io/delta/
# Github Repository: https://github.com/dandavison/delta
install git-delta
# --- END: GITHUB RELATED STUFF ---

# --- START: NVIM RELATED STUFF ---
# Name: Neovim
# Description: Vim-fork focused on extensibility and usability
# Website: https://neovim.io/
# Github Repository: https://github.com/neovim/neovim/
install neovim python3-neovim

# Name: fzf
# Description: A command-line fuzzy finder
# Website: https://junegunn.github.io/fzf/
# Github Repository: https://github.com/junegunn/fzf
install fzf

# Name: LazyGit
# Description: Simple terminal UI for git commands
# Website:
# Github Repository: https://github.com/jesseduffield/lazygit
copr_enable dejan/lazygit
install lazygit

# Name: Lazydocker
# Description: The lazier way to manage everything docker
# Website:
# Github Repository: https://github.com/jesseduffield/lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Name: ripgrep
# Description: ripgrep recursively searches directories for a regex pattern while respecting your gitignore
# Website:
# Github Repository: https://github.com/BurntSushi/ripgrep
install ripgrep

# Name: fd
# Description: A simple, fast and user-friendly alternative to 'find'
# Website:
# Github Repository: https://github.com/sharkdp/fd
install fd-find

# Name: jq
# Description: Command-line JSON processor
# Website: https://jqlang.org/
# Github Repository: https://github.com/jqlang/jq
install jq

# Name: Poppler
# Description: Poppler is a PDF rendering library based on the xpdf-3.0 code base.
# Website: https://poppler.freedesktop.org/
# Gitlab Repository: https://gitlab.freedesktop.org/poppler/poppler
install poppler

# Name: Zoxide
# Description: A smarter cd command. Supports all major shells.
# Website: https://crates.io/crates/zoxide
# Github Repository: https://github.com/ajeetdsouza/zoxide
install zoxide

# Name: resvg
# Description: An SVG rendering library.
# Website:
# Github Repository: https://github.com/linebender/resvg
cargo install resvg

# Name: eza
# Description: A modern alternative to ls.
# Website: https://eza.rocks/
# Github Repository: https://github.com/eza-community/eza
cargo install eza

# Name: GraphicsMagick
# Description: GraphicsMagick is the swiss army knife of image processing derived from ImageMagick
# Website: http://www.graphicsmagick.org/index.html
# Github Repository:
install GraphicsMagick GraphicsMagick-devel GraphicsMagick-perl

# Name: xclip
# Description: Command line interface to the X11 clipboard
# Website:
# Github Repository: https://github.com/astrand/xclip
install xclip

# Name: Yazi
# Description: Blazing fast terminal file manager written in Rust, based on async I/O.
# Website: https://yazi-rs.github.io/
# Github Repository: https://github.com/sxyazi/yazi
copr_enable lihaohong/yazi
install yazi
# --- END: NVIM RELATED STUFF ---

# Name: Bat
# Description: A cat(1) clone with wings, syntax highlighting and Git integration.
# Website:
# Github Repository: https://github.com/sharkdp/bat
install bat

# Name: Fastfetch
# Description: A maintained, feature-rich and performance oriented, neofetch like system information tool.
# Website:
# Github Repository: https://github.com/fastfetch-cli/fastfetch
install fastfetch

# Name: Fish Shell
# Description: fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
# Website: https://fishshell.com/
# Github Repository: https://github.com/fish-shell/fish-shell
install fish
# Set Default Shell to fish
sudo chsh -s "$(which fish)"

# Name: Strace
# Description: strace is a diagnostic, debugging and instructional userspace utility for Linux
# Website:
# Github Repository: https://github.com/strace/strace
install strace

# Name: Btop
# Description: A monitor of resources
# Website:
# Github Repository: https://github.com/aristocratos/btop
install btop

# Name:
# Description:
# Website:
# Github Repository:
