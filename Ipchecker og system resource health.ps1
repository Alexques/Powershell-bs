
function Get-IPInfo {

    param(
        [string]$IPAddress
    )

    try {
        $url = "http://ip-api.com/json/$IPAddress"
        $response = Invoke-RestMethod -Uri $url -Method Get
        return $response
    
    
    }
    catch {
        Write-Warning "Could not look up $IPAddress"
        return $null
    
    
    
    }
}
$connections = Get-NetTCPConnection -State Established | ForEach-Object {
    $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        LocalPort  = $_.LocalPort
        RemoteAddr = $_.RemoteAddress
        RemotePort = $_.RemotePort
        Process    = $proc.ProcessName
    }
}

$uniqueIPs = $connections.RemoteAddr | Where-Object { $_ -ne "127.0.0.1" -and $_ -notmatch "^192\.168\." } | Select-Object -Unique


foreach ($ip in $uniqueIPs) {
    $info = Get-IPInfo -IPAddress $ip
    Write-Host "$ip -> $($info.org) ($($info.country))"
}