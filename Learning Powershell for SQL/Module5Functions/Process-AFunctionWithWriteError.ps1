#This function will break
#Show piping in multiple people
#ErrorAction?

[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)] [string[]] $Person
)

begin {
    $badpeople = @("Drew","Rocky")
    $message = "$Person is awesome!"
}

process {
    ForEach ($p in $Person)
    {
        if ($p -in $BadPeople) {
            Write-Error ("Nope, that person isn't good!")
        }
        $message = "$p is awesome!"        
        $message
    }
}