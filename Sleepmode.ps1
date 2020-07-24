#### SETTINGS
#Start-Transcript -Path ".\sleepmode.log"
$ErrorActionPreference= 'silentlycontinue'
$Settings =  Import-CSV -Path .\sleepmode.ini
$ShutdownDelay = 7200


### FUNCTIONS
function DisplayMenu()
{
    ### MENU
    cls
    write-Host "______________________________________________________________________________________________"
    write-Host "					              Mode film actif - Menu"
    write-Host "______________________________________________________________________________________________"
    write-Host "1.Prolonger le delais de 2H00"
    write-Host "2.Etteindre immediatement"
	Write-Host "3.Mode Download"
    write-Host "4.Mode Download + Film"
	write-Host "5.Mode Mining"
	write-Host "6.Mode Mining + Film"
    write-Host "7.Quitter"
}

function SetPowerPlan([String]$PowerPlan)
{
    $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter “ElementName = '$PowerPlan'”  
    Invoke-CimMethod -InputObject $p -MethodName Activate
    DisplayMenu
    Write-Host "Power plan set to $PowerPlan"
}

function StopApps($aList)
{
    foreach($app in $aList)
    {
		Stop-Process -name $app   
    }
}

function StartApps($aList)
{
    foreach($app in $aList)
    {
		cmd /c start "$app" $app
    }
}

function Shutdown($Delay)
{
    cmd /c shutdown /s /t $Delay
}

function CancelShutdown()
{
    cmd /c shutdown /a
}



### MAIN
StopApps ($Settings | Where-Object {$_.Type -eq "NORMAL"} | % {$_.Name})
StartApps($Settings | Where-Object {$_.Type -eq "SLEEP"}  | % {$_.Path})
Shutdown(7200)
DisplayMenu

$loop = $true
while($loop -eq $true)
{
	$Choice = Read-Host "Choice [1-7]"
	switch($Choice)
	{
		1 { CancelShutdown
			Shutdown(7200)
			DisplayMenu }
			
		2 { CancelShutdown
			Shutdown 0
			DisplayMenu }	
			
		3 { SetPowerPlan 'DL' 
			CancelShutdown }
			
		4 { SetPowerPlan 'Film + DL' 
			CancelShutdown }
			
		5 { SetPowerPlan 'MINING' 
			CancelShutdown
			StartApps($Settings | Where-Object {$_.Type -eq "MINING"} | % {$_.Path}) }
		  
		6 { SetPowerPlan 'MINING+FILM' 
			CancelShutdown
			StartApps($Settings | Where-Object {$_.Type -eq "MINING"} | % {$_.Path}) }
		  
		7 { CancelShutdown
			StopApps ($Settings | Where-Object {$_.Type -eq "SLEEP"}  | % {$_.Name})
			StopApps ($Settings | Where-Object {$_.Type -eq "MINING"} | % {$_.Name})
			StartApps($Settings | Where-Object {$_.Type -eq "NORMAL"} | % {$_.Path})
			SetPowerPlan 'Performances élevées' 
			$loop = $false }
	}
}