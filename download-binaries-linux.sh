#!/bin/bash

# Download required binaries for Linux development
# Run this after cloning the repository

echo "Downloading required binaries for Linux..."

RESOURCES_DIR="src-tauri/resources"

# Create resources directory if it doesn't exist
mkdir -p "$RESOURCES_DIR"

# Download yt-dlp for Linux
echo "Downloading yt-dlp for Linux..."
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$RESOURCES_DIR/yt-dlp"
chmod +x "$RESOURCES_DIR/yt-dlp"

# Download ffmpeg for Linux (static build)
echo "Downloading ffmpeg for Linux..."
wget -q https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -O /tmp/ffmpeg.tar.xz
tar -xf /tmp/ffmpeg.tar.xz -C /tmp
cp /tmp/ffmpeg-*-amd64-static/ffmpeg "$RESOURCES_DIR/ffmpeg"
chmod +x "$RESOURCES_DIR/ffmpeg"
rm -rf /tmp/ffmpeg*

# Download Whisper model
echo "Downloading Whisper model..."
curl -L https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin -o "$RESOURCES_DIR/ggml-base.en.bin"

# Download Whisper binary (you'll need to build this from source or provide a URL)
echo "Note: Whisper binary needs to be built from source or downloaded separately"
echo "Visit: https://github.com/ggerganov/whisper.cpp"
echo "You can try downloading a pre-built binary from releases if available"

# Try to download whisper binary if releases are available
echo "Attempting to download whisper binary from GitHub releases..."
WHISPER_BINARY_URL="https://github.com/ggerganov/whisper.cpp/releases/latest/download/whisper-blas-bin-Linux.zip"
if curl -L --fail --silent --head "$WHISPER_BINARY_URL" > /dev/null; then
    echo "Found whisper binary, downloading..."
    curl -L "$WHISPER_BINARY_URL" -o "/tmp/whisper.zip"
    unzip -j "/tmp/whisper.zip" "*/whisper" -d "$RESOURCES_DIR" 2>/dev/null || echo "Could not extract whisper binary"
    chmod +x "$RESOURCES_DIR/whisper" 2>/dev/null
    rm -f "/tmp/whisper.zip"
else
    echo "No pre-built whisper binary available. You'll need to build from source."
fi

echo "Done! Binaries downloaded to $RESOURCES_DIR"

# List what we downloaded
echo ""
echo "Downloaded files:"
ls -la "$RESOURCES_DIR"