param(
    [string]$Port = "COM3",
    [int]$BaudRate = 115200,
    [switch]$ListPorts
)

if ($ListPorts) {
    Get-ItemProperty -Path "HKLM:\HARDWARE\DEVICEMAP\SERIALCOMM" -ErrorAction SilentlyContinue |
        Select-Object -Property * -ExcludeProperty PSPath,PSParentPath,PSChildName,PSDrive,PSProvider |
        Format-List
    exit 0
}

$serial = [System.IO.Ports.SerialPort]::new($Port, $BaudRate, "None", 8, "One")
$serial.ReadTimeout = 50
$serial.WriteTimeout = 500
$serial.DtrEnable = $true
$serial.RtsEnable = $true
$serial.NewLine = "`n"

try {
    $serial.Open()
    Write-Host "Connected to $Port at $BaudRate baud. Press Ctrl+C to close." -ForegroundColor Green

    while ($serial.IsOpen) {
        try {
            $incoming = $serial.ReadExisting()
            if ($incoming.Length -gt 0) {
                [Console]::Write($incoming)
            }
        } catch {
        }

        while ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "Enter") {
                $serial.Write("`r`n")
                [Console]::WriteLine()
            } elseif ($key.Key -eq "Backspace") {
                $serial.Write([char]8)
                [Console]::Write("`b `b")
            } elseif ($key.KeyChar -ne [char]0) {
                $serial.Write($key.KeyChar)
                [Console]::Write($key.KeyChar)
            }
        }

        Start-Sleep -Milliseconds 10
    }
} finally {
    if ($serial.IsOpen) {
        $serial.Close()
    }
    $serial.Dispose()
}
