function Get-MonkGitInfo {

    [CmdletBinding()]
    param()

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git is not installed."
    }

    $isRepo = $false

    git rev-parse --is-inside-work-tree *> $null

    if ($LASTEXITCODE -eq 0) {
        $isRepo = $true
    }

    if (-not $isRepo) {

        return [PSCustomObject]@{
            IsGitRepo = $false
            Branch    = $null
            Commit    = $null
            Remote    = $null
            Tags      = @()
        }

    }

    $commit = git rev-parse --short HEAD 2>$null

    if (-not $commit) {
        $commit = "Unknown"
    }

    $branch = git branch --show-current 2>$null

    if (-not $branch) {
        $branch = "Unknown"
    }

    $remote = git remote get-url origin 2>$null

    if (-not $remote) {
        $remote = "None"
    }

    $tags = git tag

    [PSCustomObject]@{
        IsGitRepo = $true
        Branch    = $branch.Trim()
        Commit    = $commit.Trim()
        Remote    = $remote.Trim()
        Tags      = $tags
    }

}
