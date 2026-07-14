$ErrorActionPreference = "Stop"

$version = Get-Content ".\version.json" |
    ConvertFrom-Json

$tag = "v{0}.{1}.{2}" -f `
    $version.Major,
    $version.Minor,
    $version.Patch

Write-Host ""
Write-Host "========================================"
Write-Host "        GIT RELEASE TAG"
Write-Host "========================================"
Write-Host ""

$existing = git tag

if ($existing -contains $tag) {

    Write-Host "Tag already exists: $tag" -ForegroundColor Yellow
    exit 0

}

git tag $tag

Write-Host ""
Write-Host "✓ Created tag $tag"

Write-Host ""
Write-Host "Current Tags:"
git tag
