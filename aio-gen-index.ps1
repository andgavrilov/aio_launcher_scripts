#Requires -Version 5.0

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptpath
$currentDir = Get-Location
$filePath = ".\aiorepo.index"

Set-Location -Path $scriptDir

$lastFile = Get-ChildItem -Filter "*.lua" | Sort-Object -Descending | Select-Object -First 1

Write-Output "[" | Out-File -FilePath $filePath

Get-ChildItem -Filter "*.lua" | ForEach-Object {
    Write-Output "{" | Out-File -FilePath $filePath -Append
    Write-Output "`"file`": `"$($_.Name)`"," | Out-File -FilePath $filePath -Append
    Get-Content $_.FullName -Encoding UTF8 | ForEach-Object {
        if ($_ -match '^--\s*[a-zA-Z]*\s*=') {
            $matches = [regex]::Matches($_, '^--\s*([a-zA-Z]*)\s*=')
            $key = $matches[0].Groups[1].Value
            $value = $_ -replace '^--\s*[a-zA-Z]*\s*=\s*', ''
            Write-Output "`"$key`": $value," | Out-File -FilePath $filePath -Append
        }
    }
    Write-Output "`"md5sum`": `"$(Get-FileHash $_.FullName -Algorithm MD5 | Select-Object -ExpandProperty Hash)`"".ToLower() | Out-File -FilePath $filePath -Append
    if ($_.Name -eq $lastFile.Name) {
        Write-Output "}" | Out-File -FilePath $filePath -Append
    }
    else {
        Write-Output "}," | Out-File -FilePath $filePath -Append
    }
}

Write-Output "]" | Out-File -FilePath $filePath -Append

Set-Location -Path $currentDir