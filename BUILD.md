# Building Grably with GitHub Actions

This guide explains how to use GitHub Actions to build Grably for all platforms automatically.

## Automatic Builds

### Release Builds
When you create a git tag starting with `v` (e.g., `v1.0.0`), GitHub Actions will automatically:

1. Build the application for Windows, macOS, and Linux
2. Download all required binaries for each platform
3. Create installer packages
4. Create a GitHub release with downloadable files

```bash
# Create and push a release tag
git tag v1.0.0
git push origin v1.0.0
```

### Manual Builds
You can manually trigger builds from the GitHub web interface:

1. Go to the **Actions** tab in the GitHub repository
2. Select the **"Build and Release"** workflow
3. Click **"Run workflow"**
4. Choose your options:
   - **Branch**: Select which branch to build from
   - **Create Release**: Check this to create a release (optional)
5. Click **"Run workflow"**

## What Gets Built

The GitHub Actions workflow will build:

### Windows
- `Grably_*_x64-setup.exe` - Windows installer
- `Grably_*_x64.msi` - MSI installer package

### macOS  
- `Grably_*_universal.dmg` - Universal DMG (Intel + Apple Silicon)

### Linux
- `Grably_*_amd64.AppImage` - Portable AppImage
- `grably_*_amd64.deb` - Debian package

## Required Binaries

All builds automatically include the required binaries:

- **yt-dlp**: Latest version for each platform
- **ffmpeg**: Static builds for maximum compatibility  
- **Whisper model**: Base English model (`ggml-base.en.bin`)
- **Whisper binary**: Platform-specific executable (where available)

## Build Status

- ✅ **Windows**: Fully automated with all binaries
- ✅ **macOS**: Fully automated with all binaries  
- ✅ **Linux**: Automated with ffmpeg and yt-dlp (whisper may need manual setup)

## Troubleshooting

### Failed Builds
If a build fails, check the Actions logs:

1. Go to Actions tab
2. Click on the failed workflow run
3. Expand the failed job to see error details

### Missing Binaries
The workflow will fail if binary downloads fail. Common issues:

- **Network timeouts**: Re-run the workflow
- **Changed download URLs**: Update the workflow file
- **Missing whisper binaries**: Some platforms may not have pre-built whisper binaries

### Platform-Specific Issues

**Windows:**
- Requires Visual Studio Build Tools (handled automatically in CI)
- PowerShell execution policy (handled automatically)

**macOS:**
- May require code signing for distribution (not implemented yet)
- Gatekeeper warnings for unsigned binaries

**Linux:**
- Requires system dependencies (installed automatically)
- AppImage may need `--no-sandbox` flag on some systems

## Next Steps

After a successful build:

1. **Test the binaries** on each platform
2. **Update the changelog** with new features
3. **Announce the release** to users
4. **Update documentation** if needed

The automated builds ensure that all users get the same experience across platforms with all required dependencies included.