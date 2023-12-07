#Demo 1: Running cmdlets

#What cmdlets can I run? Find out with a cmdlet!
Get-Command

#Approved Verbs
Get-Verb

#What does a cmdlet do, without running it?
Get-Help Get-Process

#Parameter support
Get-Help Get-Process -Detailed

#Let's actually run a cmdlet!
Get-Process

#We can assign output to a variable, too
$procs = Get-Process
$procs

#More cmdlets? Sure!
#How about reading a file?
#What happens if a cmdlet requires a parameter?
Get-Content

#Or include it
Get-Content -Path C:\JunkFiles\133190802033147869_blue_simplex.2


#get everything in a path?
Get-ChildItem #current path
Get-Childitem -Path C:\JunkFiles #remote path

#Oh yeah, and aliases
Get-ChildItem -Path C:\JunkFiles
Get-Help Get-ChildItem -Detailed

#Get a date object
Get-Date -Year 2020

#How about writing things out to the screen?
Write-Host "Here's a message"


#Demo 2 The Pipeline
# Two-line way
#Let's see what happens when we pipe the Get-Process cmdlet to another cmdlet that does something with the output
Get-Process
Get-Process | Out-File -FilePath C:\lab\myprocs.txt
Get-Process | Export-CSV -Path C:\lab\myprocs.csv
Get-Process | Out-GridView

#Works with variables, too
$procs = Get-Process
$procs
$procs | Out-GridView

#Select-Object is a great cmdlet to pipe things to, if you want a subset of things resturned
Get-ChildItem | Select-Object
Get-ChildItem | Select-Object name
Get-ChildItem | Select-Object lastwritetime
Get-ChildItem | Select-Object name, lastwritetime

#The triple pipe! Let's get everything in a certain path, then only select certain properties, and then output the results
Get-ChildItem | Select-Object name, lastwritetime | Out-File C:\lab\superpipe.txt

#You can also use parenthesis with cmdlets!
Get-ChildItem -Path (Resolve-Path ~)


#Hm, what's this?
Get-Date
Get-Date | Select-Object dayofweek 
#how did I know to do this? Stay tuned!


