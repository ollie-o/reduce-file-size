#!/bin/bash

IMPORT_PATH="./photos"
SMALLER_PATH="./photos_smaller"

# Check if mogrify is installed
if ! command -v mogrify &> /dev/null; then
    echo "ImageMagick is not installed. Installing ImageMagick..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first and rerun this script."
        exit 1
    fi

    # Install ImageMagick
    brew install imagemagick
    
    # Check if installation was successful
    if ! command -v mogrify &> /dev/null; then
        echo "Failed to install ImageMagick. Exiting."
        exit 1
    fi
fi

# Create the destination directory if it doesn't exist
mkdir -p "$SMALLER_PATH"

# Remove all files except .gitkeep from the destination directory
find "$SMALLER_PATH" -mindepth 1 ! -name '.gitkeep' -delete

# Copy files from import path to smaller path
cp -a "$IMPORT_PATH/." "$SMALLER_PATH"

# Change to the smaller path directory
cd "$SMALLER_PATH" || exit

# Find files with specific extensions and pass them to mogrify
find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) -exec mogrify -quality 75 {} +

echo "Image quality adjustment complete."