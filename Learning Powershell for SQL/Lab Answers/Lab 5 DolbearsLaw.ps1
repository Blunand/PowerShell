function Get-TemperatureFromCricket
{
    param (
        [Parameter(Mandatory=$true)] [int] $Chirps
    )    

    $Temperature = 50 + ($Chirps - 40) / 4
    $Temperature
}