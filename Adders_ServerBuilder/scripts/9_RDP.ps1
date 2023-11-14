# PowerShell Script to Enable Remote Desktop and Configure NLA Settings

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script! Please run as Administrator."
    exit
}

# Enable Remote Desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0

# Allow Remote Desktop through Windows Firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

Write-Host "Remote Desktop has been enabled." -ForegroundColor Green

# Ask User for Network Level Authentication (NLA) Preference
$nlaPreference = Read-Host "Do you want to enable Network Level Authentication (NLA) for Remote Desktop? (yes/no)"

if ($nlaPreference -eq "yes")
{
    # Enable NLA for Remote Desktop
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
    Write-Host "Network Level Authentication (NLA) for Remote Desktop has been enabled." -ForegroundColor Green
}
elseif ($nlaPreference -eq "no")
{
    # Disable NLA for Remote Desktop
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 0
    Write-Host "Network Level Authentication (NLA) for Remote Desktop has been disabled." -ForegroundColor Yellow
}
else
{
    Write-Host "Invalid input. NLA setting for Remote Desktop has not been changed." -ForegroundColor Red
}
