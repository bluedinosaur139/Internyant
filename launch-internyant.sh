#!/bin/bash

CHROMIUM_DIR="$HOME/chromium"

# Check if Chromium repo exists
if [ ! -d "$CHROMIUM_DIR" ]; then
  echo "Cloning Chromium repo..."
  git clone --depth=1 https://github.com/chromium/chromium.git "$CHROMIUM_DIR"
else
  echo "Updating Chromium repo..."
  cd "$CHROMIUM_DIR"
  git pull
fi

# Launch Chromium with extensions by their IDs
"$CHROMIUM_DIR"/out/Default/chrome \
  --enable-extensions \
  --load-extension=bgnkhhnnamicmpeenaelnjfhikgbkllg,mnjggcdmjocbbbhaepdhchncahnbgone,knplfmfnffhggljlkecljlmlegkflhnl
