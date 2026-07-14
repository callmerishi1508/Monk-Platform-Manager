Import-Module Pester -MinimumVersion 6.0.0 -Force

$config = New-PesterConfiguration

$config.Run.Path = ".\tests"

$config.Output.Verbosity = "Detailed"

$config.TestResult.Enabled = $true

$config.TestResult.OutputPath = ".\tests\TestResults.xml"

Invoke-Pester -Configuration $config

$config.CodeCoverage.Enabled = $true

$config.CodeCoverage.Path = @(
    ".\modules\Monk.Platform\Public",
    ".\modules\Monk.Platform\Private"
)

$config.CodeCoverage.Enabled = $true

$config.CodeCoverage.Path = @(
    ".\modules\Monk.Platform\Public",
    ".\modules\Monk.Platform\Private"
)

$config.CodeCoverage.OutputFormat = "JaCoCo"

$config.CodeCoverage.OutputPath = ".\tests\Coverage.xml"