#Get all the tables from adventureworks2019adventureworks2019
$tables = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2019\tables

#Go through each table, build a table name (schema + name), then write each to a file in the C:\Lab folder
foreach ($t in $tables) {
    $tablename = $t.schema + "." + $t.name
    $t.script() | Out-File -FilePath "C:\lab\$tablename.sql"
}

#get the person.address table and script out all the indexes to a file
$person = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2019\tables | where-object {$_.Schema -eq "Person" -and $_.Name -eq "Address"}
$person.indexes.script() | Out-File C:\lab\personindexes.sql

#Create a new, empty database named "Empty Database"
#Really, this is the easiest way... otherwise you need to create objects, file groups, etc...
invoke-sqlcmd -ServerInstance localhost -database master -query "CREATE DATABASE EmptyDatabase"

#Get all the HR schema tables, script them, then run the script on a different instance.
#We'll also include an advanced scripting option to give us the indexes in the script
#Note that this requires us to have the schema created... and the User Defined Data Types!
#And don't XML forget schema collections!
#Dependancy chaining can be hard in larger scripting exercises

#Get the source schema, we'll need that too:
$schema = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2019\schemas | where-object {$_.Name -eq "HumanResources"}
$schema.script() | Out-File -filepath "C:\lab\hrschema.sql"
invoke-sqlcmd -ServerInstance localhost -Database EmptyDatabase -InputFile "C:\lab\hrschema.sql"

#UDDTs used by the tables...
$uddts = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2019\userdefineddatatypes
$uddts.script() | Out-File -filepath "C:\lab\hruddts.sql"
invoke-sqlcmd -ServerInstance localhost -Database EmptyDatabase -InputFile "C:\lab\hruddts.sql"

#XMLSchemaCollections used by the tables...
$xmlscs = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2019\XMLSchemaCollections| where-object {$_.Schema -eq "HumanResources"}
$xmlscs.script() | Out-File -filepath "C:\lab\hrxmlscs.sql"
invoke-sqlcmd -ServerInstance localhost -Database EmptyDatabase -InputFile "C:\lab\hrxmlscs.sql"

$hrtabs = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2019\tables | where-object {$_.Schema -eq "HumanResources"}
$ScriptingServerObject = New-Object Microsoft.SqlServer.Management.Smo.Server("localhost")
$ScriptingOptions = New-Object Microsoft.SqlServer.Management.Smo.Scripter($ScriptingServerObject)
$ScriptingOptions.options.Indexes = $true
ForEach ($h IN $HrTabs){
     $ScriptingOptions.SCRIPT($h) | Out-File -filepath "C:\lab\hrtables.sql" -Append
 }
 invoke-sqlcmd -ServerInstance localhost -Database EmptyDatabase -InputFile "C:\lab\hrtables.sql"
 
 #Challange... can you do all of that with scripting options?