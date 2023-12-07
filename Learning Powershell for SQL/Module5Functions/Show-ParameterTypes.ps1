#Here's a bunch of different parameters and how you declare them
[cmdletbinding()]
param (
    #Different data types
    [Parameter(Mandatory=$false)] [int] $ANumber,
    [Parameter(Mandatory=$false)] [string] $AString,
    [Parameter(Mandatory=$false)] [datetime] $ADate = (Get-Date),

    #Can pass arrays, too!    
    [Parameter(Mandatory=$false)] [int[]] $AnArrayOfNumbers,
    [Parameter(Mandatory=$false)] [string[]] $AnArrayOfStrings,

    #Controlling input!    
    [Parameter(Mandatory=$false)] [ValidateSet("A","B","C","D")] [string] $LetterChoice
)

begin {
    $OutputString = "Here's what you passed me:"
}

process {
    if ($ANumber) {
        $OutputString = $OutputString + " the number $ANumber"
    }

    if ($AString) {
        $OutputString = $OutputString + " the string $AString"
    }

    if ($ADate) {
        $OutputString = $OutputString + " the date $ADate"
    }

    if ($AnArrayOfNumbers) {
        $OutputString = $OutputString + " an array of numbers that contain: $AnArrayOfNumbers"
    }
    
    if ($AnArrayOfStrings) {
        $OutputString = $OutputString + " an array of strings that contain: $AnArrayOfStrings"
    }

    if ($LetterChoice) {
        $OutputString = $OutputString + " a letter I forced you to choose: $LetterChoice"
    }

    if ($OutputString -eq "Here's what you passed me:")
    {
        $OutputString = $OutputString + " nothing!"
    }

}

end {
    $OutputString
}