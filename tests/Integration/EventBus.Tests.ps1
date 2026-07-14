BeforeAll {
    Import-Module "$PSScriptRoot\..\..\modules\Monk.Platform\Monk.Platform.psd1" -Force
}

Describe "Event Bus" {

    It "Publishes events without throwing" {

        {
            (Get-Module Monk.Platform).Invoke({

                Publish-MonkEvent `
                    -Event "PlatformUpdated" `
                    -Data @{ Test = $true }

            })

        } | Should -Not -Throw

    }

}