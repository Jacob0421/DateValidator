."$PSScriptRoot\Modules\ValidateJSONData.ps1"
."$PSScriptRoot\Modules\ValidateTextData.ps1"
."$PSScriptRoot\Modules\ValidateXMLData.ps1"

# TODO: remove this. Created For testing
Remove-Variable -Scope local -Name "*Error*", "*Valid*" -ErrorAction SilentlyContinue

$ConfigLocation = "$PSScriptRoot\Config\DateValidatorConfig.xml"
$ValidExtensions = "xml|txt|json"

if (-not (Test-Path $ConfigLocation)) {
    Throw "Config Location Not found.`nPath Provided: $ConfigLocation"
}

$Config = New-Object xml
$Config.Load($ConfigLocation)

$AlertingPeriod = $Config.Config.ConigurationItems.AlertingPeriod

$Config.Config.Files.File | Select-Object Directory, Name, Description | ForEach-Object {
    $FileDirectory = $_.Directory
    $FileName = $_.Name
    $Description = $_.Description


    #### Input sanitation ####
    if (-not ($FileDirectory[-1] -eq "\")) {
        $FileDirectory += "\"
    }

    $FileExtension = $FileName.Split(".")[1]

    if (-not ($FileExtension)) {
        $ErrorOutput += "File Name ($FileName) does not contain a file extension. Please Check config and correct.`n"
        return
    }
    if ($ValidExtensions -notlike "*$FileExtension*") {
        $ErrorOutput += "Extension provided for filename '$FileName' is not a valid extension. Valid extensions are: $ValidExtensions`n"
        return
    }
    ##############################

    $FilePath = $FileDirectory + $FileName

    if (-not (Test-Path $FilePath)) {
        $ErrorOutput += "File Path provided does not exist. ($FilePath)`n"
        return
    }

    switch ($FileExtension) {
        'json' { $ValidationResult = ValidateJSONFile -Path $FilePath -AlertingPeriod $AlertingPeriod }
        'txt' { $ValidationResult = ValidateTxtFile -Path $FilePath -AlertingPeriod $AlertingPeriod }
        'xml' { $ValidationResult = ValidateXMLFile -Path $FilePath -AlertingPeriod $AlertingPeriod }
        Default {}
    }


    Remove-Variable -Scope local -Name "*File*", "Description", "*Valid*" -ErrorAction SilentlyContinue
}



Throw $ErrorOutput
