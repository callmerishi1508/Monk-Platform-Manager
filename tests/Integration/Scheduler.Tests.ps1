Describe "Scheduler Integration" {

    It "Scheduler commands exist" {

        Get-Command Register-MonkTask |
            Should -Not -BeNullOrEmpty

    }

}