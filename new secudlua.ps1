$Action = New-ScheduledTaskAction `
    -Execute "PowerShell.exe" `
    -Argument '-ExecutionPolicy Bypass -File "C:\Users\AleksanderVestveitOl\OneDrive - Informasjonsteknologi og Medieproduksjon\Skrivebord\powershell skrips\Kalender skript.ps1"'

$Trigger = New-ScheduledTaskTrigger -Daily -At "07:50 AM"

Register-ScheduledTask -TaskName "MorningRoutine" -Action $Action -Trigger $Trigger