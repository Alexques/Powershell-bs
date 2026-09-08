# ===== CONFIG =====
$sitesToBlock = @(
    "discord.com", "www.discord.com"
)
$appsToBlock = @("Discord", "Steam","Microsoft Store")
$minutes = 25
# ==================

$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$marker = "# FOCUSMODE"

# Block sites
foreach ($site in $sitesToBlock) {
    Add-Content $hostsPath "127.0.0.1 $site $marker"
}

Write-Host "Focus mode ON for $minutes minutes." -ForegroundColor Red

# Loop: keep killing blocked apps until time runs out
$endTime = (Get-Date).AddMinutes($minutes)

while ((Get-Date) -lt $endTime) {
    foreach ($app in $appsToBlock) {
        Get-Process -Name $app -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    Start-Sleep -Seconds 5
}

# Unblock sites when time is up
(Get-Content $hostsPath) | Where-Object { $_ -notmatch $marker } | Set-Content $hostsPath

Write-Host "Focus mode OFF. Sites unblocked." -ForegroundColor Green


foreach($min in $minutes){
    Write-Host $min
}