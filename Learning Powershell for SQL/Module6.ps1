#Demo 1

#Loading the Module
Set-ExecutionPolicy RemoteSigned

Import-Module SQLSERVER

Get-Command -Module SQLSERVER

#Using Invoke-SQLCmd
Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "SELECT TOP 10 AddressID, AddressLine1, City, PostalCode FROM Person.Address"

#If you installed PowerShell 7...
#Fixing the ModulePath of VSCode (only if you get the error I got!):
#Open Extension Settings
#Find: "PowerShell Additional EXE Paths"
#Add "Windows X64 PowerShell", "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" to the "item" and "path" sections respectively, no quotes
#Find: "PowerShell Default Version"
#Enter: "Windows X64 PowerShell" (no quotes)
#Restart VS Code

#Demo 2

#Browse to the drive
#aliases...
cd SQLSERVER:\
dir
cd SQL

#What servers does it know about by default?
dir

#Connect to a server\instance
cd localhost\default

#Let's see what we got!
dir

#Now let's get all the databases
cd databases
dir

#Put them in a variable
$dbs = get-childitem

#And what can we see?
$dbs | get-member
$dbs | select-object name, status, size, createdate

$dbs | out-gridview

#Methods too!
$dbs.SetOffline()

#What happens in management studio?

$dbs.SetOnline()

#Remember we can filter!
$dbs = $dbs | Where-Object {$_.Name -eq "AdventureWorks2019"}
$dbs

#There's a lot of stuff to look at:
#procs
cd AdventureWorks2019
cd storedprocedures
get-childitem

#what procs have recompiles in them?
get-childitem | where-object {$_.Recompile -eq $true}

#What about system objects?
get-childitem -force

#views

cd ..
cd views
get-childitem

#what views are schemabound?
get-childitem | where-object {$_.IsSchemaBound -eq $true}


#logins?
cd ..
cd ..
cd logins
Get-ChildItem
$logins = Get-ChildItem
$logins | get-member

#We can also get really detailed info about our indexes, too
$AllTables = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\Databases\AdventureWorks2019\tables
$AllIndexes = $AllTables.Indexes
$AllIndexes
$AllIndexes | Get-Member

#Let's measure our indexes
#How many per table
$AllIndexes | Group-Object -Property Parent

#Too hard to read?
$AllIndexes | Group-Object -Property Parent | Out-GridView

#
#Demo 3
#

#And what can we do?
$dbs | get-member
$dbs.UpdateIndexStatistics()


#tables with foriegn keys?
$AddressTable = Get-ChildItem | Where-Object {$_.Name -eq "Address"}
$Fks = $AddressTable.EnumForeignKeys()
$Fks
#Remember this, we'll come back to it

#Execute a query
Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "SELECT * FROM Person.Person"


#And don't forget server-level options!
$instance = Get-ChildItem -Path SQLSERVER:\SQL\localhost | Where-Object {$_.DisplayName -eq "DEFAULT"}
$instance.VersionString
$instance.ReadErrorLog()

#Bonus: How do I restart a SQL Server Service?
get-service

#but how do we get "our" instance, in a multi-instance environment?
get-service | where-object {$_.DisplayName -like "*(MSSQLSERVER)*" -and $_.Name -eq "MSSQLSERVER"}

#admin rights!
get-service | where-object {$_.DisplayName -like "*(MSSQLSERVER)*" -and $_.Name -eq "MSSQLSERVER"} | restart-service