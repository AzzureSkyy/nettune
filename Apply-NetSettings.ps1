<#
.NOTES
    Project   : nettune
    Author    : AzzureSkyy
    Watermark : AzzureSkyy
    Source    : https://github.com/AzzureSkyy/nettune
    Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
#>
$ErrorActionPreference = 'SilentlyContinue'
$netsh = "$env:SystemRoot\System32\netsh.exe"
$log = "C:\NetTune\apply.log"

& $netsh int tcp set global autotuninglevel=normal | Out-Null
& $netsh int tcp set heuristics disabled | Out-Null
& $netsh int tcp set global rsc=enabled | Out-Null

$adapter = (Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*BE200*" -and $_.Status -eq 'Up' } | Select-Object -First 1).Name
if ($adapter) {
	$desired = [ordered]@{
		"MIMO Power Save Mode"   = "No SMPS"
		"Preferred Band"         = "4. Prefer 6GHz band"
		"Throughput Booster"     = "Enabled"
		"Roaming Aggressiveness" = "1. Lowest"
		"Transmit Power"         = "5. Highest"
		"802.11n/ac/ax/be Wireless Mode" = "4. 802.11ax"
		"Channel Width for 5GHz" = "20 MHz Only"
		"Channel Width for 6GHz" = "Auto"
	}
	foreach ($k in $desired.Keys) {
		$cur = (Get-NetAdapterAdvancedProperty -Name $adapter -DisplayName $k).DisplayValue
		if ($cur -ne $desired[$k]) {
			Set-NetAdapterAdvancedProperty -Name $adapter -DisplayName $k -DisplayValue $desired[$k] -NoRestart
			Add-Content $log "$(Get-Date -f s) Reset '$k' from '$cur' to '$($desired[$k])'"
		}
	}
	Get-CimInstance -Namespace root\wmi -ClassName MSPower_DeviceEnable |
		Where-Object InstanceName -like "*$((Get-NetAdapter -Name $adapter).PnPDeviceID)*" |
		ForEach-Object { if ($_.Enable) { Set-CimInstance -InputObject $_ -Property @{ Enable = $false } } }
}

& "$env:SystemRoot\System32\powercfg.exe" /setacvalueindex SCHEME_CURRENT 19cac1f9-1c6d-4a8f-8b3f-4f0a3c8b0d1d 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
& "$env:SystemRoot\System32\powercfg.exe" /setactive SCHEME_CURRENT
# AzzureSkyy
