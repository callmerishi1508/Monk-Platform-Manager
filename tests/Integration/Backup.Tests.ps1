Describe "Backup Integration" {

    It "Creates backup successfully" {

        { Backup-MonkPlatform } |
            Should -Not -Throw

    }

}