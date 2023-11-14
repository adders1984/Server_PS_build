# Configure DHCP Server

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script! Please run as Administrator."
    exit
}

# Install DHCP Server
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Confirm Installation
if ((Get-WindowsFeature -Name DHCP).InstallState -eq "Installed")
{
    Write-Host "DHCP Server installed successfully." -ForegroundColor Green
}
else
{
    Write-Host "Failed to install DHCP Server." -ForegroundColor Red
    exit
}

# User Input for DHCP Scope Configuration
$scopeName = Read-Host "Enter the DHCP Scope Name"
$startRange = Read-Host "Enter the Start IP Range (e.g., 192.168.13.1)"
$endRange = Read-Host "Enter the End IP Range (e.g., 192.168.13.100)"
$subnetMask = Read-Host "Enter the Subnet Mask (e.g., 255.255.255.128)"
$gateway = Read-Host "Enter the Default Gateway (e.g., 192.168.13.126)"
$dnsServer = Read-Host "Enter the DNS Server IP (e.g., 192.168.13.124)"

# Configure DHCP Scope
Add-DhcpServerv4Scope -Name $scopeName -StartRange $startRange -EndRange $endRange -SubnetMask $subnetMask
Set-DhcpServerv4OptionValue -DnsServer $dnsServer -Router $gateway

Write-Host "DHCP Configuration Complete." -ForegroundColor Green
