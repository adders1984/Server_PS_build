# Script descriptions
$scriptDescriptions = @{
    '1' = 'Enter_Key_Information'
    '2' = 'IP_and_Hostname'
    '3' = 'Storage_Pool'
    '4' = 'DCPROMO'
    '5' = 'AD_and_Directories'
    '6' = 'Default_Domain_Policy
     Account_lockout
     Int_Logon_Msg
     Last_user_Logon'
    '7' = 'GPO_Control_Panel'
    '8' = 'Features_and_Roles
     DHCP
     BACK_UP'
    '9' = 'RDP'
}

# Script paths
$scriptPaths = @{
    '1' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\1_Enter_Key_Information.ps1"
    '2' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\2_Server_IP_Hostname.ps1"
    '3' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\3_Storage_Pool.ps1"
    '4' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\4_DCPROMO.ps1"
    '5' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\5_AD_and_Directories.ps1"
    '6' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\6_Default_Domain_Policy"
    '7' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\7_GPO_ControlPanel.ps1"
    '8' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\8_FEATURES_and_ROLES.ps1"
    '9' = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\9_RDP.ps1"
}

function Check-ScriptCompletion {
    param (
        [string]$scriptNumber
    )
    $completionMarkerPath = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\Completed_${scriptNumber}.txt"
    return Test-Path $completionMarkerPath
}

function Show-Menu {
    param (
        [string]$Title = 'My Menu'
    )
    Clear-Host
    Write-Host "   

=============== $Title ===============         
          --..,_                     _,.--.
             '.'.                .'__ o  `;__.     
                '.'.            .'.'`  '---'  
                  '.`'--....--'`.'
                    '--....--'` 
===================================================== 
*2K8 BUILDS-IGNORE STEP 3 AND MANUALLY CONFIGURE RAID
*2K12 ONWARDS REQUIRE MANUAL CHANGES TO SCRIPT 3
"

    $sortedKeys = $scriptDescriptions.Keys | Sort-Object { [int]$_ }
    foreach ($scriptNum in $sortedKeys) {
        $description = $scriptDescriptions[$scriptNum]
        $color = if (Check-ScriptCompletion -scriptNumber $scriptNum) { 'Green' } else { 'White' }
        Write-Host "${scriptNum}: $description" -ForegroundColor $color
    }
    Write-Host "Q: Exit" -ForegroundColor White
}


function Run-Script {
    param (
        [string]$scriptNumber
    )
    $scriptPath = $scriptPaths[$scriptNumber]
    $completionMarkerPath = "C:\Users\Administrator\Desktop\Adders_ServerBuilder\Scripts\Completed_${scriptNumber}.txt"

    Write-Host "Running Script at $scriptPath..." -ForegroundColor Yellow
    try {
        Invoke-Expression -Command $scriptPath
        New-Item -Path $completionMarkerPath -ItemType "file" -Force
        Write-Host "Script completed." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred while running the script: $_" -ForegroundColor Red
    }
}

do {
    Show-Menu -Title 'ADDERS_SERVER_BUILDER'
    $input = Read-Host "Please make a selection"
    if ($scriptPaths.ContainsKey($input)) {
        Run-Script -scriptNumber $input
    } elseif ($input -eq 'Q') {
        break
    } else {
        Write-Host "Invalid selection, please try again" -ForegroundColor Red
    }
    Show-Menu -Title 'ADDERS_SERVER_BUILDER' # Redraw the menu after script execution
} 
while ($input -ne 'Q')
