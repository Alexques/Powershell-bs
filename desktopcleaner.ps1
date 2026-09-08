


$extensionsToClean = @(".zip", ".mp3", ".mp4", ".exe", ".msi", ".tmp")
$excludeList        = @("important_backup.zip", "project_final.zip")


#############################################
$daysOld             = 8 #Hvormange dager gammel
#############################################

$targetPaths         = @(###################################################################### alt som bruker onedrive må bli satt skjølv
    "$env:USERPROFILE\Downloads",
    "$env:TEMP",
)
$logFile             = "$env:USERPROFILE\Downloads\cleanup_log.txt"

$filesToDelete = Get-ChildItem -Path $targetPaths -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Extension -in $extensionsToClean -and
        $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld) -and
        $_.Name -notin $excludeList
    }

if ($filesToDelete.Count -eq 0) {
    Write-Host "No files matched the criteria. Nothing to do."
    exit
}

Write-Host "`nThe following files are candidates for deletion:`n"
for ($i = 0; $i -lt $filesToDelete.Count; $i++) {
    Write-Host "$i`: $($filesToDelete[$i].Name)  (last modified $($filesToDelete[$i].LastWriteTime))"
}

# --- ASK WHICH ONES TO KEEP ---
Write-Host "`nType the numbers of any files you want to KEEP, separated by commas (e.g. 1,3)."
Write-Host "Leave blank to delete everything listed above."
$keepInput = Read-Host "Numbers to keep"

$keepIndexes = @()
if ($keepInput.Trim() -ne "") {
    $keepIndexes = $keepInput -split "," | ForEach-Object { $_.Trim() -as [int] }
}

# --- DELETE THE REST, WITH LOGGING ---
for ($i = 0; $i -lt $filesToDelete.Count; $i++) {
    if ($keepIndexes -contains $i) {
        Write-Host "Skipping (kept): $($filesToDelete[$i].Name)"
        continue
    }

    $file = $filesToDelete[$i]
    "$($file.Name) deleted on $(Get-Date)" | Out-File -Append $logFile
    Remove-Item $file.FullName -Confirm -ErrorAction SilentlyContinue
}

Write-Host "`nDone. Check $logFile for a record of what was deleted."
