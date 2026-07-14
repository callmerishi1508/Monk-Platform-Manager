function Get-MonkMetrics {

    [CmdletBinding()]
    param()

    $disk = Get-PSDrive C
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    $memory = Get-CimInstance Win32_OperatingSystem

    [PSCustomObject]@{
        CPU = [math]::Round($cpu.CounterSamples.CookedValue,2)

        MemoryUsedGB =
            [math]::Round(
                ($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory)/1MB,
                2
            )

        MemoryTotalGB =
            [math]::Round(
                $memory.TotalVisibleMemorySize/1MB,
                2
            )

        DiskFreeGB =
            [math]::Round(
                $disk.Free/1GB,
                2
            )

        DiskUsedGB =
            [math]::Round(
                $disk.Used/1GB,
                2
            )
    }
}

function Get-MonkSystemHealth {

    $metrics = Get-MonkMetrics

    $memoryPercent = [math]::Round(
        ($metrics.MemoryUsedGB / $metrics.MemoryTotalGB) * 100,
        2
    )

    $diskPercent = [math]::Round(
        ($metrics.DiskUsedGB / ($metrics.DiskUsedGB + $metrics.DiskFreeGB)) * 100,
        2
    )

    $cpuThreshold    = Get-MonkSetting "Thresholds.CPU"
    $memoryThreshold = Get-MonkSetting "Thresholds.Memory"
    $diskThreshold   = Get-MonkSetting "Thresholds.Disk"

    [PSCustomObject]@{
        CPUPercent    = $metrics.CPU
        MemoryPercent = $memoryPercent
        DiskPercent   = $diskPercent

        CPUHealthy    = ($metrics.CPU -lt $cpuThreshold)
        MemoryHealthy = ($memoryPercent -lt $memoryThreshold)
        DiskHealthy   = ($diskPercent -lt $diskThreshold)
    }
}

function Watch-MonkPlatform {

    [CmdletBinding()]
    param(
        [int]$Refresh = 5
    )

    while ($true) {

        Clear-Host

        Write-Host ""
        Write-Host "========================================="
        Write-Host "        MONK AI PLATFORM"
        Write-Host "========================================="
        Write-Host ""

        $metrics = Get-MonkMetrics

        Write-Host ("CPU        : {0} %" -f $metrics.CPU)
        Write-Host ("Memory     : {0}/{1} GB" -f $metrics.MemoryUsedGB,$metrics.MemoryTotalGB)
        Write-Host ("Disk       : {0} GB Free" -f $metrics.DiskFreeGB)

        Write-Host ""

        Get-MonkPlatformStatus |
            Format-Table -AutoSize

        Start-Sleep $Refresh

    }

}