$downloadsPath = "$env:USERPROFILE\Downloads"

$categoryMap = @{
    ".png"  = "Images"
    ".avif" = "Images"
    ".zip"  = "Archives"
    ".exe"  = "Installers"
    ".msi"  = "Installers"
    ".txt"  = "Documents"
    ".docx" = "Documents"
    ".pdf"  = "Documents"
    ".jpg"  = "images"
    ".mp4"  = "movies"
    ".sb3"  = "Scratch"

}

$files = Get-ChildItem $downloadsPath -File

foreach ($file in $files) {
    $ext = $file.Extension

    # Skip files with extensions not in our map (like .lnk)
    if ($categoryMap.ContainsKey($ext)) {
        $folderName = $categoryMap[$ext]
        $destFolder = Join-Path $downloadsPath $folderName

        # hvis det er ingen folder lager en ny
        if (-not (Test-Path $destFolder)) {
            New-Item -ItemType Directory -Path $destFolder | Out-Null
        }

        # flytter filene in
        Move-Item $file.FullName -Destination $destFolder
    }
}

Write-Host "Done organizing!" -ForegroundColor Green