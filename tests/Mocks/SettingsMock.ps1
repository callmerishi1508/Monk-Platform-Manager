function Get-MonkSetting {

    param($Path)

    switch ($Path) {

        "Thresholds.CPU" { 90 }

        "Thresholds.Memory" { 90 }

        "Thresholds.Disk" { 90 }

        default { $null }

    }

}