[cmdletbinding()]
param (
    [Parameter(Mandatory=$false)] [int] $DaysAhead = $null
)

process {
    $UTCDate = Get-Date    
    if ($DaysAhead) {
        $UTCDate = $UTCDate.AddDays($DaysAhead)
    }
    $UTCDate = $UTCDate.ToFileTimeUTC()
    $UTCDate
    Write-Verbose "This is verbose output"
}