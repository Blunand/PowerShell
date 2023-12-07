function Get-TemperatureFromCricketAdvanced
{
    param (
        [Parameter(Mandatory=$true)] [int] $Chirps,
        [Parameter(Mandatory=$true)] [ValidateSet("Field","Snowy","Katydid")] [string] $CricketType
    )    

    $temperature = switch($CricketType){
        "Field" { 50 + (($Chirps - 40) / 4) }
        "Snowy" { 50 + (($Chirps - 92) / 4.7) }
        "Katydid" { 60 + (($Chirps - 19) / 3) }
    }
    $Temperature
}