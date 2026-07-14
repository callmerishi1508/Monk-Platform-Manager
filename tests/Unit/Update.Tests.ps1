BeforeAll {

    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force

    . "$PSScriptRoot\..\Mocks\DockerMock.ps1"

}

Describe "Update Engine" {

    It "Update command exists" {

        Get-Command Update-MonkPlatform |
            Should -Not -BeNullOrEmpty

    }

}