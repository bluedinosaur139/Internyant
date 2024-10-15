#!/bin/bash

# Function to detect OS and install Chromium
install_chromium() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
  else
    OS=$(uname -s)
  fi

  case $OS in
    arch | manjaro)
      echo "Detected Arch-based system. Installing Chromium via pacman..."
      sudo pacman -S --noconfirm chromium
      ;;
    ubuntu | debian)
      echo "Detected Debian-based system. Installing Chromium via apt..."
      sudo apt update && sudo apt install -y chromium-browser
      ;;
    fedora)
      echo "Detected Fedora. Installing Chromium via dnf..."
      sudo dnf install -y chromium
      ;;
    opensuse)
      echo "Detected OpenSUSE. Installing Chromium via zypper..."
      sudo zypper install -y chromium
      ;;
    *)
      echo "Unsupported OS: $OS. Please install Chromium manually."
      exit 1
      ;;
  esac
}

# Install Chromium if not already installed
if ! command -v chromium &> /dev/null; then
  echo "Chromium not found. Installing Chromium..."
  install_chromium
else
  echo "Chromium is already installed."
fi

# Define the directory for Chromium's user profile
PROFILE_DIR="$HOME/.config/chromium/Default"

# Check if the pre-configured profile exists and extract if not
if [ ! -d "$PROFILE_DIR" ]; then
  echo "Extracting pre-configured Chromium profile..."
  unzip ./preconfigured-profile.zip -d "$HOME/.config/chromium/"
else
  echo "Pre-configured profile already exists."
fi

# Copy the icon to a stable location
ICON_PATH="$HOME/.local/share/icons/Internyant-icon.png"
if [ -f "./Internyant-icon.png" ]; then
  echo "Copying custom icon..."
  cp ./Internyant-icon.png "$ICON_PATH"
fi

# Copy custom desktop entry to user's local applications directory
DESKTOP_ENTRY_PATH="$HOME/.local/share/applications/internyant-browser.desktop"
if [ -f "./chromium-custom.desktop" ]; then
  echo "Installing custom desktop entry..."
  # Update the desktop entry with the correct icon path before copying
  sed -i "s|^Icon=.*|Icon=$ICON_PATH|g" ./chromium-custom.desktop
  cp ./chromium-custom.desktop "$DESKTOP_ENTRY_PATH"
  chmod +x "$DESKTOP_ENTRY_PATH"
else
  echo "Custom desktop entry not found in repo. Skipping..."
fi

# Launch Chromium with the pre-configured profile and extensions by their IDs
echo "Launching Internyant Browser..."
chromium --user-data-dir="$HOME/.config/chromium/" \
  --enable-extensions \
  --load-extension=bgnkhhnnamicmpeenaelnjfhikgbkllg,mnjggcdmjocbbbhaepdhchncahnbgone,knplfmfnffhggljlkecljlmlegkflhnl \
  --no-error-dialogs \
  --disable-logging \
  --disable-gpu \
  --disable-features=UsePortal \
  --log-level=3 \
  --search-url="https://search.brave.com/search?q=%s" >/dev/null 2>&1

