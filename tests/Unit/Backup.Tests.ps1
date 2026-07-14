BeforeAll {
    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force
}

Describe "Backup Engine" {

    It "Lists backups" {

        Get-MonkBackups |
            Should -Not -BeNullOrEmpty

    }

    It "Backup command exists" {

        Get-Command Backup-MonkPlatform |
            Should -Not -BeNullOrEmpty

    }

}