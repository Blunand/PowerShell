#This function will break
#Show piping in multiple people
#ErrorAction?

[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)] [string[]] $Person
)

begin {
    $badpeople = @("Drew","Rocky")
}

process {
    ForEach ($p in $Person)
    {
        if ($p -in $BadPeople) {
            Throw ("Nope, that ($p) person isn't good!")
        }
        $message = "$p is awesome!"        
        $message
    }
}