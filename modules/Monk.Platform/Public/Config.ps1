function Get-MonkConfiguration {

    $root = Get-MonkRoot

    [PSCustomObject]@{

        Root = $root

        ConfigDirectory = Join-Path $root "configs"

        Logs = Join-Path $root "logs"

        Backups = Join-Path $root "backups"

        Templates = Join-Path $root "templates"

        Docs = Join-Path $root "docs"

        PlatformYaml = Join-Path $root "platform.yaml"

        Environment = Join-Path $root ".env"

        DockerCompose = Join-Path $root "docker-compose.yml"

    }

}