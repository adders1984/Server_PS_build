# Create an empty hashtable
$userData = @{}

# Ask for user input
$userData['IPAddress'] = Read-Host -Prompt 'Enter the IP address (e.g., 192.168.13.124)'
$userData['Prefix'] = Read-Host -Prompt 'Enter the prefix (e.g., 25)'
$userData['DGW'] = Read-Host -Prompt 'Enter the default gateway IP (e.g., 192.168.13.126)'
$userData['Eth_interface'] = Read-Host -Prompt 'Enter the Ethernet interface (e.g., Ethernet0)'
$userData['Hostname'] = Read-Host -Prompt 'Enter the hostname (e.g., NODA-JOKSS-MR01)'
$userData['domain'] = Read-Host -Prompt 'Enter the domain (e.g., JOKSS.reliefA.navy.mil.uk)'
$userData['netBIOS'] = Read-Host -Prompt 'Enter the NETBIOS (e.g., JOKSS)'

# Export the hashtable to an XML file
$filePath = 'C:\Users\Administrator\Documents\userInfo.xml'
$userData | Export-Clixml -Path $filePath

Write-Host "Information saved to $filePath" -ForegroundColor Green
