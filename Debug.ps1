<#
.NOTES
    Project   : nettune
    Author    : AzzureSkyy
    Watermark : AzzureSkyy
    Source    : https://github.com/AzzureSkyy/nettune
    Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
#>
Start-Transcript C:\NetTune\debug.log -Force
Get-NetAdapter | Where-Object InterfaceDescription -like "*BE200*" | Format-Table Name, InterfaceDescription, Status -AutoSize
Get-ScheduledTaskInfo NetTune-EnforceSettings | Format-List LastRunTime, LastTaskResult
$adapter = (Get-NetAdapter | Where-Object InterfaceDescription -like "*BE200*").Name
Set-NetAdapterAdvancedProperty -Name $adapter -DisplayName "Preferred Band" -DisplayValue "4. Prefer 6GHz band" -NoRestart
Get-NetAdapterAdvancedProperty -Name $adapter -DisplayName "Preferred Band" | Format-Table DisplayName, DisplayValue
Stop-Transcript
# AzzureSkyy
