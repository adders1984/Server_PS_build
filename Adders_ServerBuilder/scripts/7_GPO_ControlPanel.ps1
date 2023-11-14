# Import necessary modules
Import-Module ActiveDirectory
Import-Module GroupPolicy

# Create a new GPO named "Disable Control Panel"
$GPOName = "ControlPanel"
New-GPO -Name $GPOName -Comment "This policy disables the Control Panel for users"

# Configure the policy setting to disable the Control Panel
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoControlPanel" -Type DWord -Value 1

# Fetch and list all Organizational Units
$OUs = Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName
$index = 0
$OUs | ForEach-Object {
    Write-Host "$index. $($_.Name)"
    $index++
}

# Prompt user to select OUs
$selectedOUIndices = Read-Host "Please enter the numbers corresponding to the OUs where you want to apply the GPO, separated by commas (e.g., 1,3)"
$selectedOUIndicesArray = $selectedOUIndices.Split(',')

# Link the GPO to the selected OUs
foreach ($index in $selectedOUIndicesArray) {
    $selectedOU = $OUs[$index.Trim()]
    if ($selectedOU -ne $null) {
        New-GPLink -Name $GPOName -Target $selectedOU.DistinguishedName
        Write-Host "GPO linked to OU: $($selectedOU.Name)"
    } else {
        Write-Host "Invalid selection at index $index. No GPO linked."
    }
}

Write-Host "Script execution completed."
