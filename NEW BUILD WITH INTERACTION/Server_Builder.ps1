# Main interactive script
function Show-Menu {
    param (
        [string]$Title = 'My Menu'
    )
    Clear-Host
    Write-Host "   
=============== $Title ===============         
          --..,_                     _,.--.
             `'.'.                .'`__ o  `;__.     
                '.'.            .'.'`  '---'`  `
                  '.`'--....--'`.'
                    `'--....--'` 
===================================================== "

    Write-Host "1: Enter_Key_Information" -ForegroundColor White
    Write-Host "2: IP_and_Hostname" -ForegroundColor White
    Write-Host "3: RAID" -ForegroundColor White
    Write-Host "4: DCPROMO" -ForegroundColor White
    Write-Host "5: AD_and_Directories" -ForegroundColor White
    Write-Host "6: GPO" -ForegroundColor White
    Write-Host "7: DHCP" -ForegroundColor White
    Write-Host "8: RDP" -ForegroundColor White
    Write-Host "9: Exchange" -ForegroundColor White
    Write-Host "Q: Exit" -ForegroundColor White
}

function Run-Script {
    param (
        [string]$scriptPath
    )
    Write-Host "Running Script at $scriptPath..." -ForegroundColor Yellow
    try {
        Invoke-Expression -Command $scriptPath
        Write-Host "Script completed." -ForegroundColor Green
    } catch {
        Write-Host "An error occurred while running the script: $_" -ForegroundColor Red
    }
}

$script1Path = "C:\Users\Administrator\Documents\Scripts\1_Enter_Key_Information.ps1"
$script2Path = "C:\Users\Administrator\Documents\Scripts\2_Server_IP_Hostname.ps1"
$script3Path = "C:\Users\Administrator\Documents\Scripts\3_RAID.ps1"
$script4Path = "C:\Users\Administrator\Documents\Scripts\4_DCPROMO.ps1"
$script5Path = "C:\Users\Administrator\Documents\Scripts\5_AD_and_Directories.ps1"
$script6Path = "C:\Users\Administrator\Documents\Scripts\6_GPO.ps1"
$script7Path = "C:\Users\Administrator\Documents\Scripts\7_DHCP.ps1"
$script8Path = "C:\Users\Administrator\Documents\Scripts\8_RDP.ps1"


do {
    Show-Menu -Title 'ADDERS_SERVER_BUILDER'
    $input = Read-Host "Please make a selection"
    switch ($input) {
        '1' {
            Run-Script -scriptPath $script1Path
        }
        '2' {
            Run-Script -scriptPath $script2Path
        }
        '3' {
            Run-Script -scriptPath $script3Path
        }
        '4' {
            Run-Script -scriptPath $script4Path
        }
        '5' {
            Run-Script -scriptPath $script5Path
        }
        '6' {
            Run-Script -scriptPath $script6Path
        }
        '7' {
            Run-Script -scriptPath $script7Path
        }
        '8' {
            Run-Script -scriptPath $script8Path
        }
        '9' {
            Run-Script -scriptPath $script9Path
        }
        'Q' {
            break
        }
        default {
            Write-Host "Invalid selection, please try again" -ForegroundColor Red
        }
    }
    if ($input -match '^[123]$') {
        Write-Host "Press any key to continue ..." -ForegroundColor Gray
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Clear-Host
    }
} 
while ($input -ne 'Q')
