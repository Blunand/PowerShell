#Demo 1: Exploring object properties
#Let's get a list of files into a variable, nothing new here
$files = get-childitem -Path C:\JunkFiles
$files

#Now, what properties does $files contain
$files | Get-Member

#Wow, that's a lot! Now how can we access some of those things?
#Method 1: Select-Object, which we've seen, useful for selecting multiple properties at once
$files | select-object Name, FullName, CreationTime, LastWriteTime

#Method 2: .Property names for use in scripting and/or logical operators
$files.FullName
$files.CreationTime
$files.LastWriteTime

#properties of properties
$files.name | get-member

#The files type
$files.GetType()
$files[0].GetType()

#Demo 2
#Object properties and the pipeline
#Let's explore measure-object

$files = get-childitem -Path C:\JunkFiles

$files | Measure-Object
$files | Get-Member
$files | Measure-Object -Property Length -Sum
$files | Measure-Object -Property Length -Average
$files | Measure-Object -Property Length -Average -Sum -Maximum -Minimum

#Everything is an object!
$files | Measure-Object -Property Length -Average -Sum -Maximum -Minimum | Select-Object Maximum

$measures = $files | Measure-Object -Property Length -Average -Sum -Maximum -Minimum
$measures.maximum


#Grouping objects
$files | group-object -Property extension
$filegroups = $files | group-object -Property extension
$filegroups.group


#Sorting objects
$files | sort-object -Property creationtime

#Expanding on select object to get only top results
$files | sort-object -Property creationtime | select-object fullname, creationtime -first 2

#a taste of expressions (bonus)
#properties of properties
$files | select-object name, length
$files | select-object name, @{Label="Name Length";Expression={$_.name.length}}

#Demo 3
#Methods
#Let's explore things we can do to date objects
$date = Get-Date
$date | Get-Member
$date.ToFileTime()
$date.AddDays(30)

#Did anything change?
$date
$date = $date.AddDays(30)


#String methods are cool too
$sometext = "Drew is bald"
$sometext | Get-member
$sometext.Replace("bald","rad")
$sometext

#didn't save, why?
#have to assign the change!

$sometext = $sometext.Replace("bald","rad")
$sometext

#Arrays of objects and methods
$Array = @("Rocky","Sammy","Jake")
$Array | get-member
$Array.Replace("Sammy","Sam")
$Array[0].Replace("Sammy","Sam")


#Demo 5
#Creating your own objects
$carobject = [pscustomobject] @{
    color = "white"
    make = "mercedes"
    model = "c43"
    doors = 4
}

$carobject
$carobject | get-member
$carobject.make

#Adding a property to an existing object
$carobject | Add-Member -MemberType NoteProperty -Name Year -Value 2018
$carobject | get-member