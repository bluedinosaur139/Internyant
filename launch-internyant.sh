#!/bin/bash

# Define the directory for Chromium
CHROMIUM_DIR="$HOME/chromium"

# Clone the Chromium repo if it doesn't exist
if [ ! -d "$CHROMIUM_DIR" ]; then
  echo "Cloning Chromium repo..."
  git clone --depth=1 https://github.com/chromium/chromium.git "$CHROMIUM_DIR"
else
  echo "Updating Chromium repo..."
  cd "$CHROMIUM_DIR"
  git pull
fi

# Navigate to the Chromium directory
cd "$CHROMIUM_DIR"

# Set up build configuration if it's the first time
if [ ! -d "out/Default" ]; then
  echo "Generating build files..."
  gn gen out/Default
fi

# Build Chromium
echo "Building Chromium (this may take a while)..."
ninja -C out/Default chrome

# Launch Chromium with extensions by their IDs
echo "Launching Chromium..."
./out/Default/chrome \
  --enable-extensions \
  --load-extension=bgnkhhnnamicmpeenaelnjfhikgbkllg,mnjggcdmjocbbbhaepdhchncahnbgone,knplfmfnffhggljlkecljlmlegkflhnl
