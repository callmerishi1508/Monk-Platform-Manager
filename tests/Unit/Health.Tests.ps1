BeforeAll {

    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force

    . "$PSScriptRoot\..\Mocks\DockerMock.ps1"

}

Describe "Health Engine" {

    It "Returns health object" {

        Invoke-MonkHealth |
            Should -Not -BeNullOrEmpty

    }

    It "Returns system health" {

        Get-MonkSystemHealth |
            Should -Not -BeNullOrEmpty

    }

    It "CPU property exists" {

        (Get-MonkSystemHealth).PSObject.Properties.Name |
            Should -Contain "CPUHealthy"

    }

}