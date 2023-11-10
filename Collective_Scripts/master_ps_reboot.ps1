$stateFilePath = "C:\Users\Administrator\Documents\statefile.json"


# Import Server Manager Module
Import-Module ServerManager

# Install Active Directory Domain Services Role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import Active Directory Module
Import-Module ADDSDeployment

function InstallADDS {
    param(
        [Parameter(Mandatory=$true)]
        [string]$domainName,

        [Parameter(Mandatory=$true)]
        [System.Security.SecureString]$securePassword
    )

    Install-ADDSForest `
        -DomainMode "Win2012R2" `
        -DomainName $domainName `
        -SafeModeAdministratorPassword $securePassword `
        -Force:$true `
        -InstallDNS:$true `
        -Confirm:$false

    Write-Host "Active Directory Domain Services installed. Please reboot and rerun this script." -ForegroundColor Green
}

function ConfigureAD {
    $groupData = Import-Csv -Path C:\Users\Administrator\Documents\groups.csv
    $import_ou = Import-Csv -Path "C:\Users\Administrator\Documents\ou.csv"
    $import_groups = Import-Csv -Path C:\Users\Administrator\Documents\groups.csv
    $csvFile = "C:\Users\Administrator\Documents\Directories.csv"
    $import_shares = Import-Csv -Path C:\Users\Administrator\Documents\share_list.csv
    $HomePath = "\\TRNG-RNKSS-AF01\Home$"
    $ProfilePath = "\\TRNG-RNKSS-AF01\Profile$"
    $import_users = Import-Csv -Path C:\Users\Administrator\Documents\domain_users.csv

    $import_ou | ForEach-Object {
        if ($_.State -eq 'present') {
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

    Write-Host "Script completed successfully." -ForegroundColor Green
}

function Main {
    $state = $null
    if (Test-Path $stateFilePath) {
        try {
            $state = Get-Content $stateFilePath -Raw | ConvertFrom-Json
        } catch {
            Write-Host "Failed to load state file. The file may be corrupted." -ForegroundColor Red
            Remove-Item $stateFilePath -ErrorAction SilentlyContinue
        }
    }

    if (-not $state) {
        $hostName = Read-Host -Prompt "Enter the hostName"
        $domainName = Read-Host -Prompt "Enter the FQDN"
        $securePassword = Read-Host -Prompt "Enter the Safe Mode Administrator password" -AsSecureString

        $state = @{
            hostName = $hostName
            domainName = $domainName
            securePasswordAsPlainText = $securePassword | ConvertFrom-SecureString
            stage = "installADDS"
        }

        $state | ConvertTo-Json | Set-Content $stateFilePath
    }

    $securePassword = $state.securePasswordAsPlainText | ConvertTo-SecureString

    switch ($state.stage) {
        "installADDS" {
            InstallADDS -domainName $state.domainName -securePassword $securePassword
            $state.stage = "configureAD"
            $state | ConvertTo-Json | Set-Content $stateFilePath
        }

        "configureAD" {
            ConfigureAD
            Remove-Item $stateFilePath -ErrorAction SilentlyContinue
        }

        default {
            Write-Host "Unknown script stage. Exiting." -ForegroundColor Red
        }
    }
}

Main
