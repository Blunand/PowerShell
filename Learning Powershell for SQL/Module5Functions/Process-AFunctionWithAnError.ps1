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
        for ($x = 0; $x -lt 3; $x = $x + 1) {
            $quotients += $d / $x
        }
    }
}

end {
    $quotients
}
