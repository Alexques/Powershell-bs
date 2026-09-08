#Componet Object model lager en pop-up 
$shell = New-Object -ComObject Shell.Application
$folder = $shell.BrowseForFolder(0,"Select folderen",0,0)

if ($folder -ne $null){ #hvis folder er ikke lik null altså at du har valgt en mappe så blir selected path til folder
    $selectedPath = $folder.Self.Path
    Write-Host "du valgte: $selectedPath"






###start med å finne alle bildene i en folderen du valgte 
    Get-ChildItem -Path $selectedPath -Recurse -Include *.jpg, *.jpeg, *.png, *.gif -File -ErrorAction SilentlyContinue |
        Get-FileHash -Algorithm SHA256 | #bruker en algoritme som skjekke etter duplikat
        Group-Object -Property Hash|#legger alt i en grupp
        Where-Object {
            $_.Count -gt 1
        }|#finner bare framm grupper med mer en 1 
        ForEach-Object{
            $_.Group | Select-Object -Skip 1
        }|#tar nedd i slik at den enne blir slette
        ForEach-Object{
            Write-Host "sletter $(Split-Path -Path $_.Path -Leaf)"
            Remove-Item -Path $_.Path
        }#sletter alle duplicate filer

}
else{
    Write-Host "no folder"#slik at programet ikke går foraltid

}

