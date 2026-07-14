BeforeAll {
    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force
}

Describe "Module Loading" {

    It "Imports successfully" {
        Get-Module Monk.Platform | Should -Not -BeNullOrEmpty
    }

    It "Exports public commands" {

        (Get-Command -Module Monk.Platform).Count |
            Should -BeGreaterThan 20

    }

    It "Exports Start-MonkPlatform" {

        Get-Command Start-MonkPlatform |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Repair-MonkPlatform" {

        Get-Command Repair-MonkPlatform |
            Should -Not -BeNullOrEmpty

    }

    It "Exports Backup-MonkPlatform" {

        Get-Command Backup-MonkPlatform |
            Should -Not -BeNullOrEmpty

    }

}