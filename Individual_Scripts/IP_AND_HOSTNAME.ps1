# Define the network configuration settings

#UPDATE THESE SETTINGS TO REFLECT YOUR ENVIROMENT

$ipAddress = "192.168.13.124"
$prefixLength = 25
$gateway = "192.168.13.126"
$interfaceAlias = "Ethernet"
$newComputerName = "NODA-JOKSS-MR01"

# Configure the IP address
New-NetIPAddress -IPAddress $ipAddress -PrefixLength $prefixLength -InterfaceAlias $interfaceAlias -DefaultGateway $gateway

# Rename the computer
Rename-Computer -NewName $newComputerName -Force -Restart


#NEED TO ADD FIREWALL RULE

