#!/bin/bash

CONFIG="$HOME/.config/ytmp3"

# Check if config exists
if [ -f "$CONFIG" ]; then
	file_dir=$(cat "$CONFIG")
else
	read -p "Enter download directory: " file_dir
	echo "$file_dir" > "$CONFIG"
fi

# Check if directory exists
mkdir -p "$HOME/$file_dir"

# Enter URL
read -p "Enter URL: " url

# Download and convert to MP3
yt-dlp -x \
    --cookies-from-browser firefox \
    --audio-format mp3 \
    -o "$HOME/$file_dir/%(title)s.%(ext)s" \
    "$url"

echo "Track downloaded! Saved to $HOME/$file_dir"
