#demo 1 
#sample logical operators

$a = 5
$b = 6
$c = 5

#equals
$a -eq $b

#not equals
$a -ne $b

#greater than and less than
$b -gt $a
$b -lt $a

#greater than or equal to, less than or equal to
$a -ge $b
$a -le $b
$a -le $c

#translates better like this
$a -le $b -and $a -ge $c
$a -le $b -and $a -ge $b

#Date compares
$Today = Get-Date
$Tomorrow = Get-Date
$Tomorrow = $Tomorrow.AddDays(1)
$Today -gt $Tomorrow
$Today -lt $Tomorrow
$Today -lt "12/28/1979 01:14 AM"

#boolean logic
$a = $true
$b = $true
$c = $false

$a –and $b
$a –or $b
$a -or $b
$a -or $c
$a –or $b –and $c
$a -and $c -or $b

($a –or $c) –and $b
($a –or $b) –and $c
-not $a
-not $c


#string test operations
$sometext = "Drew's cat barks a lot"
$sometext -like "cat"
#why false?
$sometext -like "*cat*"

#why not true?
$sometext = "cat"
$sometext -like "cat"

#start and end filtering
$sometext = "cats are mean"
$sometext -like "cat*"

$sometext = "I don't like the cat"
$sometext -like "*cat"

#What about searching for asterisks?
$sometext = 'What is result of 2 * 2?'
$sometext -like "*"

#Um...
$sometext = 'What is result of 2 - 2?'
$sometext -like "*"

$sometext -like "***"

#Regex and escape characters to the rescue!e
$sometext = 'What is result of 2 * 2?'
$sometext -match "\*"
$sometext = 'What is result of 2 - 2?'
$sometext -match "\*"

#Array operators
$array = @("Drew","brent","rocky")
$array -contains "Drew"
$array -contains "bront"

#does case matter?
$array -contains "drew"

#what about going the other way, a value in an array?
$somestring = "drew"

$somestring -in $array
$somestring -notin $array


#Demo 2
#And now, the moment we've all been waiting for... testing and filtering objects!
#Let's go back to our file objects
$files = Get-ChildItem -Path C:\JunkFiles

#What if I want to filter just for files that have a .0 extension?
#Well, extenstion is a property...
$files | Get-Member
$files.extension

#Let's pipe the variable to Where-Object
$files | Where-Object {$_.Extension -eq ".0"}

#Nice. Now, let's expand it... find every file with .0 as an extension and every file CREATED after 4 PM
$files | Where-Object {$_.Extension -eq ".3" -and $_.CreationTime -gt '12/31/2017 4:00 PM'}

#And now... let's get crazy
#filter our file list down... and then rename them
$dot0files = $files | Where-Object {$_.Extension -eq ".0" -and $_.CreationTime -gt '12/31/2017 4:00 PM'}

#this doesn't work... why?
$dot0files.extension = ".4"
$dot0files | Get-Member

#so what do we do? Just a full rename
#check out the whatif...
$dot0files | rename-item -NewName {$_.Name.Replace('.0','.4')} -WhatIf


#Demo 3
#while loops
$x = 0
while ($x -lt 100)
{
    $x
    $x = $x + 1
}

#For Loops
#Let's say you want to do something a number of times... like, rename all four extensions?

$files = Get-ChildItem -Path C:\JunkFiles
for ($x = 0; $x -lt 4; $x = $x + 1) {
    $dotfiles = $files | Where-Object {$_.Extension -eq ".$x" -and $_.CreationTime -gt '12/31/2017 4:00 PM'}
    $dotfiles | rename-item -NewName {$_.Name.Replace(".$x","." + ($x + 3))} -WhatIf
}

#Foreach
#The last example was good... if we know how many extensions to look for
#Instead, let's loop over EVERY file in the collection, and add 3 to the number
#Now we're getting somewhere...

$files = Get-ChildItem -Path C:\JunkFiles
foreach ($f in $files) {
    $extensionNumber = $f.extension.replace(".",$null)
    $extensionNumber = $extensionNumber.ToInt32($null)
    $f | rename-item -NewName {$_.Name.Replace(".$extensionNumber","." + ($extensionNumber + 3))} -WhatIf
}



#Demo 4
#If/then/else
$files = Get-ChildItem -Path C:\JunkFiles
foreach ($f in $files) {
    $extensionNumber = $f.extension.replace(".",$null)
    $extensionNumber = $extensionNumber.ToInt32($null)
    if ($extensionNumber % 2 -eq 0) {
        Write-Host "File extension is even"
    } else {
        Write-Host "File extension is odd"
    }
}

#switch
$files = Get-ChildItem -Path C:\JunkFiles
foreach ($f in $files) {
    $extensionNumber = $f.extension.replace(".",$null)
    $extensionNumber = $extensionNumber.ToInt32($null)
    switch ($extensionNumber) {
        1 {"File extension 1 for file " + $f.name}
        2 {"File extension 2 for file " + $f.name}
        default {"Too lazy to go on, here's file " + $f.name}
    }
}
