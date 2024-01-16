."$PSScriptRoot\Get-Status.ps1"

Function ValidateJSONFile ($Path, $AlertingPeriod) {
    $FileStream = New-Object System.IO.FileStream $Path, 'Open', 'Read', 'ReadWrite'
    $StreamReader = New-Object System.IO.StreamReader($FileStream)

    $JSONConfig = ConvertFrom-Json $StreamReader.ReadToEnd()

    $StreamReader.Close()
    $StreamReader.Dispose()

    $RawExpiry = [DateTime]::ParseExact($JSONConfig.ExpiryDate, 'yyyy-MM-dd', $null)
    $GracePeriod = [int] (($JSONConfig.GracePeriod) -replace "[^0-9]", "")
    $ExpiryWithGrace = $RawExpiry.AddDays($GracePeriod)

    $Status = Get-Status -ExpiryRaw $RawExpiry -GracePeriod $GracePeriod -ExpiryWithGrace $ExpiryWithGrace

    $Output = [PSCustomObject]@{
        Status                = $Status
        Expiry                = $RawExpiry
        ExpiryWithGracePeriod = $ExpiryWithGrace
        GracePeriod           = $GracePeriod
    }

    $Output
}