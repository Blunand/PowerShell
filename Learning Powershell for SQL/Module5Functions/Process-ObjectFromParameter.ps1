#A "file as a function"
#Part of module 5

[cmdletbinding()]
param (
    [Parameter(Mandatory=$false)] [int] $DaysAhead = $null
)

begin {
    $UTCDate = Get-Date
    if ($ForDate) {
        $UTCDate.AddDays($DaysAhead)
    }
}

process {
    $UTCDate = $UTCDate.ToFileTimeUTC()
}

end {
    $UTCDate
}