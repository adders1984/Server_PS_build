# Import XML file
$xml = Import-Clixml -Path "C:\Users\Administrator\Desktop\Adders_ServerBuilder\vars.xml"

# Extract hostname and domainname from XML
$domain = $xml.domain

Set-ADDefaultDomainPasswordPolicy -Identity $domain -PasswordHistoryCount 3 -LockoutObservationWindow 00:05 -LockoutThreshold 3 -ComplexityEnabled 1 -MinPasswordLength 6 -LockoutDuration 00:05 -MaxPasswordAge 180:00:00:00 -MinPasswordAge 01:00:00:00


# Prompt for the interactive logon message
$title = Read-Host "Enter the title for the logon message"
$message = Read-Host "Enter the logon message"

# Import Group Policy module
Import-Module GroupPolicy

try {
    # Get the Default Domain Policy GPO
    $gpo = Get-GPO -Name "Default Domain Policy"

    # Configure the interactive logon message
    Set-GPRegistryValue -Name "Default Domain Policy" -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "legalnoticetitle" -Value $title -Type String
    Set-GPRegistryValue -Name "Default Domain Policy" -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "legalnoticecaption" -Value $message -Type String

    # Output success message
    Write-Host "Interactive logon message set successfully."
} catch {
    # Handle any errors
    Write-Error "An error occurred: $_"
}

# Import Group Policy module
Import-Module GroupPolicy

try {
    # Get the Default Domain Policy GPO
    $gpo = Get-GPO -Name "Default Domain Policy"

    # Disable displaying the last user name
    Set-GPRegistryValue -Name "Default Domain Policy" -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "DontDisplayLastUserName" -Value 1 -Type DWord

    # Output success message
    Write-Host "The 'Do not display last user name' policy has been set successfully in the Default Domain Policy."
} catch {
    # Handle any errors
    Write-Error "An error occurred: $_"
}
