#Requires -Version 5.0

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location -Path $dir
$lastFile = Get-ChildItem | Sort-Object -Descending | Select-Object -First 1

Write-Output "[" | Out-File -FilePath .\aiorepo.index

Get-ChildItem -Filter "*.lua" | ForEach-Object {
    Write-Output "{" | Out-File -FilePath .\aiorepo.index -Append
    Write-Output "`"file`": `"$($_.Name)`"," | Out-File -FilePath .\aiorepo.index -Append
    Get-Content $_.FullName -Encoding UTF8 | ForEach-Object {
        if ($_ -match '^--\s*[a-zA-Z]*\s*=') {
            $matches = [regex]::Matches($_, '^--\s*([a-zA-Z]*)\s*=')
            $key = $matches[0].Groups[1].Value
            $value = $_ -replace '^--\s*[a-zA-Z]*\s*=\s*', ''
            Write-Output "`"$key`": $value," | Out-File -FilePath .\aiorepo.index -Append
        }
    }
    Write-Output "`"md5sum`": `"$(Get-FileHash $_.FullName -Algorithm MD5 | Select-Object -ExpandProperty Hash)`"" | Out-File -FilePath .\aiorepo.index -Append
    if ($_.Name -eq $lastFile.Name) {
        Write-Output "}" | Out-File -FilePath .\aiorepo.index -Append
    }
    else {
        Write-Output "}," | Out-File -FilePath .\aiorepo.index -Append
    }
}

Write-Output "]" | Out-File -FilePath .\aiorepo.index -Append