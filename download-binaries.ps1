# Windows PowerShell script to download required binaries for development
# Run this after cloning the repository

Write-Host "Downloading required binaries for Windows..."

$RESOURCES_DIR = "src-tauri\resources"

# Create resources directory if it doesn't exist
if (-not (Test-Path $RESOURCES_DIR)) {
    New-Item -ItemType Directory -Path $RESOURCES_DIR -Force
}

# Download yt-dlp for Windows
Write-Host "Downloading yt-dlp for Windows..."
$ytdlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
Invoke-WebRequest -Uri $ytdlpUrl -OutFile "$RESOURCES_DIR\yt-dlp.exe"

# Download ffmpeg for Windows (via GitHub releases)
Write-Host "Downloading ffmpeg for Windows..."
$ffmpegUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
$tempZip = "$RESOURCES_DIR\ffmpeg.zip"
Invoke-WebRequest -Uri $ffmpegUrl -OutFile $tempZip
Expand-Archive -Path $tempZip -DestinationPath $RESOURCES_DIR -Force

# Extract ffmpeg.exe from the nested directory structure
$ffmpegExtracted = Get-ChildItem -Path "$RESOURCES_DIR\ffmpeg-*" -Recurse -Name "ffmpeg.exe"
if ($ffmpegExtracted) {
    $ffmpegSourcePath = Join-Path -Path $RESOURCES_DIR -ChildPath $ffmpegExtracted
    Copy-Item -Path $ffmpegSourcePath -Destination "$RESOURCES_DIR\ffmpeg.exe" -Force
    # Clean up extracted directory
    Get-ChildItem -Path "$RESOURCES_DIR\ffmpeg-*" -Directory | Remove-Item -Recurse -Force
}
Remove-Item -Path $tempZip -Force

# Download Whisper model (same for all platforms)
Write-Host "Downloading Whisper model..."
$modelUrl = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin"
Invoke-WebRequest -Uri $modelUrl -OutFile "$RESOURCES_DIR\ggml-base.en.bin"

# Note about Whisper binary
Write-Host "Note: Whisper binary needs to be built from source or downloaded separately"
Write-Host "For Windows, you can download pre-built binaries from:"
Write-Host "https://github.com/ggerganov/whisper.cpp/releases"
Write-Host "Download whisper.exe and place it in $RESOURCES_DIR"

Write-Host "Done! Binaries downloaded to $RESOURCES_DIR"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Download whisper.exe from https://github.com/ggerganov/whisper.cpp/releases"
Write-Host "2. Place whisper.exe in $RESOURCES_DIR"
Write-Host "3. Run: npm run tauri dev"