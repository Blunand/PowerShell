#This function will break
#Part of module 5

[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)] [int[]] $dividends
)

begin {
    $quotients = @()
}

process {
    foreach ($d in $dividends) {
        for ($x = 0; $x -lt 3; $x++) {
            Write-Verbose "Attempting to divide $d by $x..."
            try {
                $quotients += $d / $x
            } catch {
                Write-Warning "Oops, looks like I can't divide that!"
            }
        }
    }
}

end {
    $quotients
}
