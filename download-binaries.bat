@echo off
rem Windows batch script to download required binaries for development
rem Run this after cloning the repository

echo Downloading required binaries for Windows...

set RESOURCES_DIR=src-tauri\resources

rem Create resources directory if it doesn't exist
if not exist "%RESOURCES_DIR%" mkdir "%RESOURCES_DIR%"

rem Download yt-dlp for Windows
echo Downloading yt-dlp for Windows...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile '%RESOURCES_DIR%\yt-dlp.exe'"

rem Download ffmpeg for Windows
echo Downloading ffmpeg for Windows...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile '%RESOURCES_DIR%\ffmpeg.zip'"
powershell -Command "Expand-Archive -Path '%RESOURCES_DIR%\ffmpeg.zip' -DestinationPath '%RESOURCES_DIR%' -Force"

rem Extract ffmpeg.exe (this is a simplified approach - may need manual extraction)
echo Please extract ffmpeg.exe from the downloaded zip file to %RESOURCES_DIR%

rem Download Whisper model
echo Downloading Whisper model...
powershell -Command "Invoke-WebRequest -Uri 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin' -OutFile '%RESOURCES_DIR%\ggml-base.en.bin'"

rem Clean up
if exist "%RESOURCES_DIR%\ffmpeg.zip" del "%RESOURCES_DIR%\ffmpeg.zip"

echo.
echo Note: You still need to:
echo 1. Extract ffmpeg.exe from the downloaded files to %RESOURCES_DIR%
echo 2. Download whisper.exe from https://github.com/ggerganov/whisper.cpp/releases
echo 3. Place whisper.exe in %RESOURCES_DIR%
echo 4. Run: npm run tauri dev
echo.
echo Done! Check %RESOURCES_DIR% for downloaded binaries.
pause