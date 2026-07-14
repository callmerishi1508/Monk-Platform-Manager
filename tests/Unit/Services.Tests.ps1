BeforeAll {

    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force

    . "$PSScriptRoot\..\Mocks\DockerMock.ps1"

}

Describe "Service Registry" {

    It "Returns services" {

        (Get-MonkServices).Count |
            Should -BeGreaterThan 0

    }

    It "Contains qdrant" {

        Get-MonkService qdrant |
            Should -Not -BeNullOrEmpty

    }

    It "Returns running status" {

        Get-MonkServiceStatus qdrant |
            Should -Be "running"

    }

}