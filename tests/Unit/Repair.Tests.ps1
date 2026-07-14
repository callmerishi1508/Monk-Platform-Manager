BeforeAll {

    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force

    . "$PSScriptRoot\..\Mocks\DockerMock.ps1"

}

Describe "Repair Engine" {

    It "Repair function exists" {

        Get-Command Repair-MonkPlatform |
            Should -Not -BeNullOrEmpty

    }

    It "Repair service exists" {

        Get-Command Repair-MonkService |
            Should -Not -BeNullOrEmpty

    }

}