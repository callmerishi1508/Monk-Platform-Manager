BeforeAll {
    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force
}

Describe "Configuration" {

    It "Returns configuration object" {

        $config = Get-MonkConfiguration

        $config |
            Should -Not -BeNullOrEmpty

    }

    It "Configuration has Root" {

        (Get-MonkConfiguration).Root |
            Should -Not -BeNullOrEmpty

    }

    It "Configuration has Logs folder" {

        Test-Path (Get-MonkConfiguration).Logs |
            Should -BeTrue

    }

}