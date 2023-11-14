# Import organizational unit data from a CSV file
$import_ou = Import-Csv -Path "C:\Users\Administrator\Desktop\Adders_ServerBuilder\csv_files\OU.csv"

# Iterate through each row of the CSV
$import_ou | ForEach-Object {
    # Check if the OU should be present (created) based on the 'State' column
    if ($_.State -eq 'present') {
        # Try to create a new organizational unit in Active Directory
        try {
            New-ADOrganizationalUnit `
                -Name $_.OU `
                -Path $_.Path `
                -ProtectedFromAccidentalDeletion $($_.Protected -as [bool]) `
                -ErrorAction Stop
            Write-Host "Organizational Unit $($_.OU) created successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to create Organizational Unit $($_.OU): $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Organizational Unit $($_.OU) is marked as 'absent'. No action taken." -ForegroundColor Yellow
    }
}

$import_groups = Import-Csv -Path C:\Users\Administrator\Desktop\Adders_ServerBuilder\csv_files\Groups.csv

foreach ($group in $import_groups) {
    $name = $group.Group
    $category = $group.Category
    $scope = $group.Scope
    $path = $group.Org_Unit

    switch ($category) {
        "Security" {
            $groupType = "Security"
        }
        "Distribution" {
            $groupType = "Distribution"
        }
        default {
            Write-Warning "Invalid group category specified: $category"
            continue
        }
    }

    switch ($scope) {
        "Global" {
            $groupScope = "Global"
        }
        "DomainLocal" {
            $groupScope = "DomainLocal"
        }
        "Universal" {
            $groupScope = "Universal"
        }
        default {
            Write-Warning "Invalid group scope specified: $scope"
            continue
        }
    }

    # Check if the group already exists
    $existingGroup = Get-ADGroup -Filter "Name -eq '$name'" -ErrorAction SilentlyContinue

    if (-not $existingGroup) {
        New-ADGroup `
            -Name $name `
            -SamAccountName $name `
            -GroupCategory $groupType `
            -GroupScope $groupScope `
            -DisplayName $name `
            -Path $path
    } else {
        Write-Host "Group '$name' already exists."
    }
}

# Import the CSV file again for LG membership assignment
$groupData = Import-Csv -Path C:\Users\Administrator\Desktop\Adders_ServerBuilder\csv_files\Groups.csv

# Loop through each row in the CSV file for LG membership assignment
foreach ($row in $groupData) {
    $groupName = $row.Group
    if (-not [string]::IsNullOrWhiteSpace($row.Members)) {
        $lgMembers = $row.Members -split ","

        # Add each LG member to the group
        foreach ($lgMember in $lgMembers) {
            $trimmedLgMember = $lgMember.Trim()
            if (-not [string]::IsNullOrWhiteSpace($trimmedLgMember)) {
                $adGroup = Get-ADGroup -Identity $trimmedLgMember -ErrorAction SilentlyContinue
                if ($adGroup) {
                    Add-ADGroupMember -Identity $groupName -Members $trimmedLgMember
                } else {
                    Write-Warning "LG not found in AD: $trimmedLgMember"
                }
            }
        }
    } else {
        Write-Warning "No LG members listed for group: $groupName"
    }
}

# CREATE DIRECTORIES

# Get the CSV file path
$csvFile = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\csv_files\Directories.csv"

# Import user data from the XML file
$filePath = 'C:\Users\Administrator\Desktop\Adders_ServerBuilder\vars.xml'
$xmlContent = [xml](Get-Content -Path $filePath)

# SET HOSTNAME FROM XML FILE
$domain = $xmlContent.userInfo.domain

# Read the CSV file into an array of objects
$dirs = Import-Csv $csvFile

# Loop through each directory in the array and create it with the specified permissions
foreach ($dir in $dirs) {
  $path = $dir.Path
  $group = $dir.Group
  $rights = $dir.Rights

  # Create the directory if it doesn't exist
  if (-not (Test-Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
  }

  # Set the permissions on the directory
  $acl = Get-Acl $path
  $acl.SetAccessRuleProtection($true, $false)

  # Add the access rule to the ACL
  $rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("$domain\$group", $rights, "ContainerInherit,ObjectInherit", "None", "Allow")
  $rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
  $rule3 = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
  $rule4 = New-Object System.Security.AccessControl.FileSystemAccessRule("CREATOR OWNER", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
  $acl.SetAccessRule($rule1)
  $acl.SetAccessRule($rule2)
  $acl.SetAccessRule($rule3)
  $acl.SetAccessRule($rule4)
  Set-Acl $path $acl
}


# CREATE SMB SHARES

$import_shares = Import-Csv -Path C:\Users\Administrator\Desktop\Adders_ServerBuilder\csv_files\SMB_shares.csv
          $import_shares | ForEach-Object {
          
            New-SmbShare `
              -Name $_.Name `
              -Path $_.Path `
              -FullAccess $_.List
          }


#CREATE DOMAIN USERS

# Define the file path for the XML file
$filePath = 'C:\Users\Administrator\Desktop\Adders_ServerBuilder\vars.xml'

# Import the XML file
$xml = Import-Clixml -Path $filePath

# Extract hostname and domainname from the XML
$hostname = $xml.Hostname
$domainname = $xml.domain

# Define the HomePath and ProfilePath using the hostname and domainname from XML
$HomePath = "\\$hostname.$domainname\Home$"
$ProfilePath = "\\$hostname.$domainname\Profile$"

# Import users from CSV
$import_users = Import-Csv -Path C:\Users\Administrator\Desktop\Adders_ServerBuilder\csv_files\Domain_users.csv

$import_users | ForEach-Object {
    $groups = $_.Group -split ','  # Split the value in the 'Group' column by comma

    # Create the new user account
    New-ADUser `
        -Name $_.Logon `
        -GivenName $_.FirstName `
        -Surname $_.Surname `
        -DisplayName $_.Logon `
        -UserPrincipalName $_.Logon `
        -SamAccountName $_.Logon `
        -AccountPassword $(ConvertTo-SecureString $_.Password -AsPlainText -Force) `
        -Enabled $True `
        -CannotChangePassword $True `
        -Path $_.Org_Unit `
        -HomeDrive "H:" `
        -HomeDirectory $($HomePath + "\" + $_.Logon) `
        -ProfilePath $($ProfilePath + "\" + $_.Logon) `
        -Title $_.Title `
        -Description $_.Description `
        -StreetAddress $_.BunkLocation `
        -Office $_.Office `
        -Department $_.Department 
                  
    # Add the user to each group
    foreach ($group in $groups) {
        Add-ADGroupMember -Identity $group -Members $_.Logon
    }
}


#CREATE HOME DRIVES

# Define the file path
$filePath = 'C:\Users\Administrator\Desktop\Adders_ServerBuilder\vars.xml'

# Import XML file
$xml = Import-Clixml -Path $filePath

# Extract hostname and domainname from XML
$hostname = $xml.Hostname
$domainname = $xml.domain

# Create a variable for the network path
$networkPath = "\\$hostname.$domainname\Home$\"

# CREATE HOME DRIVES
Get-ADUser -Filter {ObjectClass -eq "user" } | ForEach-Object {
    md "$networkPath$($_.SamAccountName)"
}

$HomeFolders = Get-ChildItem -Path $networkPath | Where-Object { $_.PSIsContainer -eq 'True' }
foreach ($HomeFolder in $HomeFolders) {
    $Path = $HomeFolder.FullName
    $Acl = (Get-Item $Path).GetAccessControl('Access')
    $Username = $HomeFolder.Name
    $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($Username, 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
    $Acl.SetAccessRule($Ar)
    $Acl.SetAccessRuleProtection($true, $false)
    Set-Acl -Path $Path -AclObject $Acl
}
         