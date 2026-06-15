<#
 ArgusOS Activation - PowerShell Launcher
 Use with: irm https://raw.githubusercontent.com/ar4us/ArgusOS-Activation/main/launcher.ps1 | iex
#>

$projectName = "ArgusOS Activation"
$version = "1.0"
$scriptUrl = "https://raw.githubusercontent.com/ar4us/ArgusOS-Activation/main/ArgusOS_AIO.cmd"
$tempFile = "$env:TEMP\ArgusOS_AIO_$([System.Guid]::NewGuid().ToString('N')).cmd"

$border = "┌" + ("─" * 56) + "┐"
$separator = "├" + ("─" * 56) + "┤"
$bottomBorder = "└" + ("─" * 56) + "┘"

$logoLines = @(
    "  ___                         ____  _____               ",
    " /   |  _____________  ______/ __ \/ ___/               ",
    "/ /| | / ___/ __  / / / / ___/ / / /\__ \               ",
    "/ ___ |/ /  / /_/ / /_/ (__  ) /_/ /___/ /               ",
    "/_/  |_/_/   \__, /\__,_/____/\____//____/               ",
    "            /____/                                      "
)

Write-Host $border -ForegroundColor DarkGray
foreach ($line in $logoLines) {
    Write-Host "│" -NoNewline -ForegroundColor DarkGray
    Write-Host $line -NoNewline -ForegroundColor Cyan
    Write-Host "│" -ForegroundColor DarkGray
}
Write-Host $separator -ForegroundColor DarkGray

$title = "  $projectName v$version - PowerShell Launcher"
$paddedTitle = $title.PadRight(56)
Write-Host "│" -NoNewline -ForegroundColor DarkGray
Write-Host $paddedTitle -NoNewline -ForegroundColor White
Write-Host "│" -ForegroundColor DarkGray

Write-Host $bottomBorder -ForegroundColor DarkGray
Write-Host ""
Write-Host " [*] Downloading activation script..." -ForegroundColor Cyan

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($scriptUrl, $tempFile)
    
    if (Test-Path $tempFile) {
        Write-Host " [✓] Script downloaded successfully!" -ForegroundColor Green
        Write-Host " [*] Launching as Administrator..." -ForegroundColor Cyan
        Write-Host ""
        
        Start-Process cmd -ArgumentList "/c `"$tempFile`"" -Verb RunAs -Wait
        
        # Cleanup
        if (Test-Path $tempFile) {
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue | Out-Null
        }
    } else {
        Write-Host " [✗] Failed to download script." -ForegroundColor Red
        Write-Host " [!] Check your internet connection and try again." -ForegroundColor Yellow
    }
} catch {
    Write-Host " [✗] Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host " [!] Alternative: Download ArgusOS_AIO.cmd manually and run as Administrator." -ForegroundColor Yellow
}

# Keep window open
if (-not ([System.String]::IsNullOrEmpty($env:PROCESSOR_ARCHITEW6432) -or $env:PROCESSOR_ARCHITEW6432 -eq '')) {
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
