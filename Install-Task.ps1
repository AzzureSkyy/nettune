<#
.NOTES
    Project   : nettune
    Author    : AzzureSkyy
    Source    : https://github.com/AzzureSkyy/nettune
    Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
#>
$action  = New-ScheduledTaskAction -Execute "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\NetTune\Apply-NetSettings.ps1"'
$t1 = New-ScheduledTaskTrigger -AtStartup
$t2 = New-ScheduledTaskTrigger -AtLogOn
$t3 = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 30)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -TaskName "NetTune-EnforceSettings" -Action $action -Trigger $t1,$t2,$t3 -Principal $principal -Force
Start-ScheduledTask -TaskName "NetTune-EnforceSettings"
Write-Host "Installed. Settings will be re-applied at startup, logon, and every 30 minutes."
