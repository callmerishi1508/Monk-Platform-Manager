BeforeAll {
    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force
}

Describe "Platform Integration" {

    It "Starts platform successfully" {

        { Start-MonkPlatform } | Should -Not -Throw

    }

    It "Returns healthy status" {

        $health = Invoke-MonkHealth

        ($health.Healthy -contains $false) |
            Should -BeFalse

    }

}