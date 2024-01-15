Function ValidateXMLFile ($Path, $AlertingPeriod) {

    $FileStream = New-Object System.IO.FileStream $Path, 'Open', 'Read', 'ReadWrite'
    $StreamReader = New-Object System.IO.StreamReader($FileStream)

    $ConfigXML = [xml] $StreamReader.ReadToEnd()

    $StreamReader.Close()
    $StreamReader.Dispose()

    $ExpiryRaw = [DateTime]::ParseExact($ConfigXML.Config.ExpiryDate, 'yyyy-MM-dd', $null)
    $GracePeriod = [int] (($ConfigXML.Config.GracePeriod) -replace "[^0-9]", "")

    Write-Host "$ExpiryRaw | $GracePeriod | $($ExpiryRaw.AddDays($GracePeriod))"

    
    Remove-Variable -Scope local -Name "*Expiry*", "*Grace*" -ErrorAction SilentlyContinue
}