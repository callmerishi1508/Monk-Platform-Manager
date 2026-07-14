Describe "Plugin Integration" {

    It "Loads demo plugin" {

        Get-MonkPlugins |
            Should -Contain "demo"

    }

}