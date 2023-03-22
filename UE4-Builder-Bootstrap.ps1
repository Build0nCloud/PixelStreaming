<#

.SYNOPSIS
Script to automate setup of environment and download of exported project. Streamer launched from StartPixelStreaming.ps1 file in project automatically.

.DESCRIPTION

.NOTES
You will need to modify the $buildExecutable variable below to match the file name for your executable in your build.

.LINK

#>

$buildExecutable = "PixelStreamingDemo.exe"
$basePath = "C:\PixelStreamer\Downloads"

Write-Output "Starting UE4-Pixel-StreamerBuild-Bootstrap.ps1 from:", $basePath

# Create basePath if unless it already exists.
if(!(Test-Path -Path $basePath )){
    New-Item -ItemType directory -Path $basePath
}

Write-Output "Installing Node.js"
Invoke-WebRequest -Uri "https://nodejs.org/dist/v12.8.1/node-v12.8.1-x64.msi" -OutFile "$basePath\node-v12.8.1-x64.msi"
Start-Process -FilePath "$basePath\node-v12.8.1-x64.msi" -ArgumentList "/quiet" -Wait
$env:Path += ";C:\Program Files\nodejs\;C:\Users\Administrator\AppData\Roaming\npm"
Write-Output "Node.js Installed"

Write-Output "Adding Windows Firewall Rules for UE4 Pixel Streaming"
New-NetFirewallRule -DisplayName 'UE4 Pixel Streamer' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 80
New-NetFirewallRule -DisplayName 'UE4 Pixel Streamer' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443
New-NetFirewallRule -DisplayName 'UE4 Pixel Streamer' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 19302-19303
New-NetFirewallRule -DisplayName 'UE4 Pixel Streamer' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8888
New-NetFirewallRule -DisplayName 'UE4 Pixel Streamer' -Direction Inbound -Action Allow -Protocol UDP -LocalPort 8888
New-NetFirewallRule -DisplayName 'UE4 Pixel Streamer' -Direction Inbound -Action Allow -Protocol UDP -LocalPort 19302-19303
Write-Output "Windows Firewall Rules Added for UE4 Pixel Streaming"


Write-Output "Install UE4 Prerequisites"
Install-WindowsFeature NET-Framework-Core
Start-Process -FilePath "C:\PixelStreamer\WindowsNoEditor\Engine\Extras\Redist\en-us\UE4PrereqSetup_x64.exe" -ArgumentList "/passive /quiet /norestart /log C:\PixelStreamer\WindowsNoEditor\Engine\Extras\Redist\en-us\UE4PreReqInstall.log" -Wait
Write-Output "UE4 Prerequisites Installed"

