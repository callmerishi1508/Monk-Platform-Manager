BeforeAll {
    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force
}

Describe "Plugin System" {

    It "Returns installed plugins" {

        Get-MonkPlugins |
            Should -Contain "demo"

    }

    It "Plugin command exists" {

        Get-Command Get-MonkPlugins |
            Should -Not -BeNullOrEmpty

    }

}