# Ask the user for information
$ipAddress = Read-Host -Prompt 'Enter the IP Address'
$prefixLength = Read-Host -Prompt 'Enter Prefix length'
$gateway = Read-Host -Prompt 'Enter the DGW'
$interfaceAlias = Read-Host -Prompt 'Enter the Interface name eg Ethernet0'
$newComputerName = Read-Host -Prompt 'Enter the Hostname'
$domainName = Read-Host -Prompt 'Enter the FQDN'


# Store the information in a hashtable for easy export
$info = @{
    IPAddress = $ipAddress
    Prefix = $prefixLength
    DGW = $gateway
    Eth_interface = $interfaceAlias
    Hostname = $newComputerName
    domain = $domainName
}

# Export the hashtable to a CSV file
$info | Out-File -FilePath 'C:\Users\Administrator\Documents\info.txt'

Write-Host "Information saved!" -ForegroundColor Green
