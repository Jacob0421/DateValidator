Function Get-Status($ExpiryRaw, $GracePeriod, $ExpiryWithGrace) {

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

    Write-Host $Status

    $Status
}