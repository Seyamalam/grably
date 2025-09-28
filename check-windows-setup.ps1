# Windows Setup Verification Script
# Run this to check if all required binaries are properly installed

Write-Host "Grably Windows Setup Verification" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

$RESOURCES_DIR = "src-tauri\resources"
$binariesFound = $true

# Check if resources directory exists
if (-not (Test-Path $RESOURCES_DIR)) {
    Write-Host "❌ Resources directory not found: $RESOURCES_DIR" -ForegroundColor Red
    Write-Host "   Run download-binaries.ps1 first!" -ForegroundColor Yellow
    exit 1
}

# Check for yt-dlp.exe
Write-Host "Checking yt-dlp.exe..." -NoNewline
if (Test-Path "$RESOURCES_DIR\yt-dlp.exe") {
    Write-Host " ✅ Found" -ForegroundColor Green
    
    # Check version
    try {
        $ytdlpVersion = & "$RESOURCES_DIR\yt-dlp.exe" --version 2>$null
        Write-Host "   Version: $ytdlpVersion" -ForegroundColor Gray
    } catch {
        Write-Host "   (Could not get version)" -ForegroundColor Yellow
    }
} else {
    Write-Host " ❌ Missing" -ForegroundColor Red
    $binariesFound = $false
}

# Check for ffmpeg.exe
Write-Host "Checking ffmpeg.exe..." -NoNewline
if (Test-Path "$RESOURCES_DIR\ffmpeg.exe") {
    Write-Host " ✅ Found" -ForegroundColor Green
    
    # Check version
    try {
        $ffmpegVersion = & "$RESOURCES_DIR\ffmpeg.exe" -version 2>$null | Select-Object -First 1
        if ($ffmpegVersion -match "ffmpeg version (\S+)") {
            Write-Host "   Version: $($matches[1])" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   (Could not get version)" -ForegroundColor Yellow
    }
} else {
    Write-Host " ❌ Missing" -ForegroundColor Red
    $binariesFound = $false
}

# Check for whisper.exe
Write-Host "Checking whisper.exe..." -NoNewline
if (Test-Path "$RESOURCES_DIR\whisper.exe") {
    Write-Host " ✅ Found" -ForegroundColor Green
} else {
    Write-Host " ❌ Missing" -ForegroundColor Red
    Write-Host "   Download from: https://github.com/ggerganov/whisper.cpp/releases" -ForegroundColor Yellow
    $binariesFound = $false
}

# Check for Whisper model
Write-Host "Checking Whisper model..." -NoNewline
if (Test-Path "$RESOURCES_DIR\ggml-base.en.bin") {
    Write-Host " ✅ Found" -ForegroundColor Green
    $modelSize = (Get-Item "$RESOURCES_DIR\ggml-base.en.bin").Length / 1MB
    Write-Host "   Size: $([math]::Round($modelSize, 1)) MB" -ForegroundColor Gray
} else {
    Write-Host " ❌ Missing" -ForegroundColor Red
    $binariesFound = $false
}

Write-Host ""

# Check Node.js
Write-Host "Checking Node.js..." -NoNewline
try {
    $nodeVersion = node --version 2>$null
    Write-Host " ✅ Found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host " ❌ Not found" -ForegroundColor Red
    Write-Host "   Install from: https://nodejs.org/" -ForegroundColor Yellow
    $binariesFound = $false
}

# Check Rust
Write-Host "Checking Rust..." -NoNewline
try {
    $rustVersion = rustc --version 2>$null
    if ($rustVersion -match "rustc (\S+)") {
        Write-Host " ✅ Found: $($matches[1])" -ForegroundColor Green
    } else {
        Write-Host " ✅ Found: $rustVersion" -ForegroundColor Green
    }
} catch {
    Write-Host " ❌ Not found" -ForegroundColor Red
    Write-Host "   Install from: https://rustup.rs/" -ForegroundColor Yellow
    $binariesFound = $false
}

Write-Host ""

# Final status
if ($binariesFound) {
    Write-Host "🎉 All requirements satisfied!" -ForegroundColor Green
    Write-Host "You can now run: npm run tauri dev" -ForegroundColor Green
} else {
    Write-Host "⚠️  Some requirements are missing." -ForegroundColor Red
    Write-Host "Please install missing components before proceeding." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Fix any missing components above"
Write-Host "2. Run: npm install"
Write-Host "3. Run: npm run tauri dev"