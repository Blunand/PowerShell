#Demo 1 Defining a Function
#Let's say we always find ourselves wanting to get a UTC Date String
#We could keep doing this:
$UTCDate = Get-Date
$UTCDate = $UTCDate.ToFileTimeUTC()
$UTCDate

#Or, we could write a function
function Get-CurrentDateInUTCFormat {
    $UTCDate = Get-Date
    $UTCDate = $UTCDate.ToFileTimeUTC()
    $UTCDate
}

#
#let's run that... and see nothing happens
#... until we actually call the function
Get-CurrentDateInUTCFormat
$UTCDateTime = Get-CurrentDateInUTCFormat
$UTCDateTime

#And running from a dot-source
#Open the file to see it
./Module5Functions/Get-CurrentDateInUTCFormat.ps1


#Demo 2
#Adding parameters
#Inline/Helper Function
function Get-CurrentDateInUTCFormatParameters 
{
    param (
        [Parameter(Mandatory=$false)] [int] $DaysAhead = $null
    )
    
    $UTCDate = Get-Date
    if ($DaysAhead) {
        $UTCDate = $UTCDate.AddDays($DaysAhead)
    }    
    $UTCDate = $UTCDate.ToFileTimeUTC()
    $UTCDate
}
Get-CurrentDateInUTCFormatParameters -DaysAhead 5

#Dot-Sourced
./Module5Functions/Get-CurrentDateInUTCFormatParameters.ps1 -DaysAhead 5

#Files from here on out...
#Different types of parameters
./Module5Functions/Show-ParameterTypes.ps1

#Do differnt types...

#Run a function with an error... what happens?
$dividends = @(44,56,77,22)
.\Module5Functions\Process-AFunctionWithAnError.ps1 -dividends $dividends 

#And now show off ErrorAction
.\Module5Functions\Process-AFunctionWithAnError.ps1 -dividends $dividends -ErrorAction Stop
.\Module5Functions\Process-AFunctionWithAnError.ps1 -dividends $dividends -ErrorAction SilentlyContinue

#An improved function with error handling and verbose output
.\Module5Functions\Process-AFunctionWithAnErrorWithTryCatch.ps1 -dividends $dividends
.\Module5Functions\Process-AFunctionWithAnErrorWithTryCatch.ps1 -dividends $dividends -Verbose


#Building in error conditions
#Write error, use ErrorAction
#Show singleton, show arrays

$PeopleIKnow = @("Brent","Todd","Peter","Drew","Allen")
.\Module5Functions\Process-AFunctionWithWriteError.ps1 -Person Brent
.\Module5Functions\Process-AFunctionWithWriteError.ps1 -Person Drew
.\Module5Functions\Process-AFunctionWithWriteError.ps1 -Person $PeopleIKnow -ErrorAction Stop
.\Module5Functions\Process-AFunctionWithWriteError.ps1 -Person $PeopleIKnow -ErrorAction SilentlyContinue
.\Module5Functions\Process-AFunctionWithWriteError.ps1 -Person $PeopleIKnow -ErrorAction Inquire


#Or go the hard way
#Show a throw example
#Show singleton, show arrays
#What does throw do?
.\Module5Functions\Process-AFunctionWithThrow.ps1
.\Module5Functions\Process-AFunctionWithThrow.ps1 -Person Brent
.\Module5Functions\Process-AFunctionWithThrow.ps1 -Person Drew

$PeopleIKnow = @("Brent","Todd","Peter","Drew","Allen")
.\Module5Functions\Process-AFunctionWithThrow.ps1 -Person $PeopleIKnow

