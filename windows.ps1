# Add or remove the Winget Package IDs in this array to customize your installation.
$packages = @(
    "7zip.7zip",
    "Adobe.Acrobat.Reader.64-bit",
    "Brave.Brave",
    "Discord.Discord",
    "Flameshot.Flameshot",
    "Git.Git",
    "GitHub.CLI",
    "Google.Chrome",
    "Google.EarthPro",
    "LocalSend.LocalSend",
    "Microsoft.PowerToys",
    "OpenWhisperSystems.Signal",
    "SumatraPDF.SumatraPDF",
    "Telegram.TelegramDesktop",
    "VSCodium.VSCodium",
    "VideoLAN.VLC",
    "qBittorrent.qBittorrent",
)

# --- Installation Loop ---
Write-Host "Starting application installation process..." -ForegroundColor Green

foreach ($package in $packages) {
    Write-Host "--------------------------------------------------"
    Write-Host "Attempting to install: $package" -ForegroundColor Cyan

    # Check if the package is already installed
    $installed = winget list --id $package -n 1
    if ($installed) {
        Write-Host "$package is already installed. Skipping." -ForegroundColor Yellow
    } else {
        # If not installed, proceed with installation
        Write-Host "Installing $package..."
        winget install -e --id $package --source winget --accept-package-agreements --accept-source-agreements
        
        # Check the exit code to see if the installation was successful
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully installed $package." -ForegroundColor Green
        } else {
            Write-Host "Failed to install $package. Exit code: $LASTEXITCODE" -ForegroundColor Red
        }
    }
}

Write-Host "--------------------------------------------------"
Write-Host "All specified applications have been processed." -ForegroundColor Green
