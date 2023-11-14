# Import user data from the XML file
$filePath = 'C:\Users\Administrator\Desktop\Adders_ServerBuilder\vars.xml'
$userData = Import-Clixml -Path $filePath

# Install the AD DS role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the ADDS deployment module
Import-Module ADDSDeployment

# Set deployment configuration for creating a new forest
$domainName = $userData['domain']
$netBIOSName = $userData['netBIOS']
$databasePath = "C:\Windows\NTDS"
$logPath = "C:\Windows\NTDS"
$sysvolPath = "C:\Windows\SYSVOL"

$safeModePassword = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force

# Configuration for Install-ADDSForest
$ADDSForestConfig = @{
    DomainName                    = $domainName
    InstallDNS                    = $true
    DomainNetbiosName             = $netBIOSName
    SafeModeAdministratorPassword = $safeModePassword
    DatabasePath                  = $databasePath
    LogPath                       = $logPath
    SysvolPath                    = $sysvolPath
    Force                         = $true
}

# Install and configure the new forest
try {
    Install-ADDSForest @ADDSForestConfig
    Write-Host "Active Directory Domain Services is now installed and the forest has been created." -ForegroundColor Green
} catch {
    Write-Host "An error occurred while installing AD DS: $_" -ForegroundColor Red
}

# After the installation, a reboot is required
if ((Read-Host "Do you want to restart now? (Y/N)") -eq 'Y') {
    Restart-Computer
}
