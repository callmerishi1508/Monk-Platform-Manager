$script:StartedServices = [System.Collections.Generic.HashSet[string]]::new()

function Clear-MonkStartedServices {
    $script:StartedServices.Clear()
}

function Test-MonkStartedService {
    param([string]$Name)
    return $script:StartedServices.Contains($Name)
}

function Add-MonkStartedService {
    param([string]$Name)
    $null = $script:StartedServices.Add($Name)
}