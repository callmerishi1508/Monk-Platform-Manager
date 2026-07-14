$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========== CLEAN =========="
Write-Host ""

$folders = @(
    "release",
    "coverage",
    "artifacts",
    "temp"
)

foreach ($folder in $folders) {

    if (Test-Path $folder) {

        Remove-Item `
            -Path $folder `
            -Recurse `
            -Force

        Write-Host "✓ Removed $folder"

    }

}

$files = @(
    "tests\TestResults.xml",
    "tests\Coverage.xml"
)

foreach ($file in $files) {

    if(Test-Path $file){

        Remove-Item `
            -Path $file `
            -Force

        Write-Host "✓ Removed $file"

    }

}

Write-Host ""
Write-Host "Clean completed."
