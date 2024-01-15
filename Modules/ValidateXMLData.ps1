Function ValidateXMLFile ($Path, $AlertingPeriod) {

    $FileStream = New-Object System.IO.FileStream $Path, 'Open', 'Read', 'ReadWrite'
    $StreamReader = New-Object System.IO.StreamReader($FileStream)

    $ConfigXML = [xml] $StreamReader.ReadToEnd()

    $StreamReader.Close()
    $StreamReader.Dispose()

    $ExpiryRaw = [DateTime]::ParseExact($ConfigXML.Config.ExpiryDate, 'yyyy-MM-dd', $null)
    $GracePeriod = [int] (($ConfigXML.Config.GracePeriod) -replace "[^0-9]", "")
    $ExpiryWithGrace = $ExpiryRaw.AddDays($GracePeriod)

    if (((Get-Date) -gt $ExpiryRaw) -and ((Get-Date) -lt $ExpiryWithGrace)) {
        $Status = "On Grace Period"
    }
    elseif ((Get-Date) -gt $ExpiryRaw) {
        $Status = "Expired"
    }
    elseif ((GetDate).AddMonths($AlertingPeriod) -gt $ExpiryRaw) {
        $Status = "Nearing Expiry"
    }
    else {
        $Status = "Good"
    }

    $Output = [PSCustomObject]@{
        Status                = $Status
        Expiry                = $ExpiryRaw
        ExpiryWithGracePeriod = $ExpiryWithGrace
        GracePeriod           = $GracePeriod
    }

    $Output
    
    Remove-Variable -Scope local -Name "*Expiry*", "*Grace*" -ErrorAction SilentlyContinue
}