#Create a variable that holds all the objects (files) in the directory E:\JunkFiles folder
$JunkFiles = Get-ChildItem -Path E:\JunkFiles

#Find the minimum, maximum, and average file sizes
$JunkFiles | Measure-Object -Property Length -Minimum -Maximum -Average

$JunkFiles | Get-member
#Create a new variable that contains ONLY the full path and last write time of the files in the folder
$LessProperties = $JunkFiles | Select-Object FullName, LastWriteTime

#Create a custom dog object with the following properties:
#Name (string)
#Breed (string)
#Age (number)
#Color (string)
#GoodDog (Boolean)
$NewDog = [pscustomobject] @{
    Name = "Rocky"
    Breed = "Yorkshire Terrier"
    Age = 9
    Color = "Blue and Gold"
    GoodDog = $true
}


#Create an array of dogs
$NewDog1 = [pscustomobject] @{
    Name = "Rocky"
    Breed = "Yorkshire Terrier"
    Age = 9
    Color = "Blue and Gold"
    GoodDog = $true
}
$NewDog2 = [pscustomobject] @{
    Name = "Jake"
    Breed = "Chocolate Lab"
    Age = 1
    Color = "Brown"
    GoodDog = $true
}
$NewDog3 = [pscustomobject] @{
    Name = "Ein"
    Breed = "Corgi"
    Age = 11
    Color = "Yellow"
    GoodDog = $true
}
$Dogs = @($NewDog1, $NewDog2, $NewDog3)

#With a date object, tell me what day of the week today falls on in 30 years
$DateObject = Get-Date
$DateObject | Get-Member
$DateObject= $DateObject.AddYears(30)
$DateObject.DayOfWeek

$DateObject = Get-Date
$DateObject.AddYears(30).DayOfWeek
