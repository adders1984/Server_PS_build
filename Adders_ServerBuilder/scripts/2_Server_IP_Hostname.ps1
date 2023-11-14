# Import the information from the XML file
$filePath = 'C:\Users\Administrator\Desktop\Adders_ServerBuilder\vars.xml'
$userData = Import-Clixml -Path $filePath

# Now you can access the stored user data like this:
$fqdn = $userData['domain']
$gateway = $userData['DGW']
$ipAddress = $userData['IPAddress']
$newComputerName = $userData['Hostname']
$interfaceAlias = $userData['Eth_interface']
$prefixLength = $userData['Prefix']

# Validate the IP address
$nullIP = $null  # Create a variable to hold the parsed IP address
if(-not [System.Net.IPAddress]::TryParse($ipAddress, [ref]$nullIP)){
    Write-Host "The IP address you entered is not valid."
    exit
}

# Validate the prefix length
if($prefixLength -lt 0 -or $prefixLength -gt 32){
    Write-Host "The prefix length should be between 0 and 32."
    exit
}

# Validate the interface alias
if(-not (Get-NetAdapter | Where-Object { $_.Name -eq $interfaceAlias })){
    Write-Host "The interface alias you entered does not exist."
    exit
}

# Configure the IP address
try {
    New-NetIPAddress -IPAddress $ipAddress -PrefixLength $prefixLength -InterfaceAlias $interfaceAlias -DefaultGateway $gateway
    Write-Host "Network configuration applied successfully."
} catch {
    Write-Host "An error occurred while applying network configuration: $_"
    exit
}

# Rename the computer
try {
    Rename-Computer -NewName $newComputerName -Force -Restart
    Write-Host "Computer will be renamed to $newComputerName and restarted."
} catch {
    Write-Host "An error occurred while renaming the computer: $_"
}