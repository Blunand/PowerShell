#Demo 1
Import-Module SQLSERVER


#Scripting out database objects
#Database level
$Database = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\Databases | Where-Object {$_.Name -eq "AdventureWorks2019"}
$Database.Script()

#All Databases
$Databases = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\Databases
$Databases.Script()

#Tables
#Couple different ways we can get them... we know about this
$Tables = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\Databases\AdventureWorks2019\Tables
$Tables

#... but let's try something different?
$Tables = $Database.Tables
$Tables

#We can script out every object
$Tables.Script()

#How about a schema?
#Back to one database
$Database = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\Databases | Where-Object {$_.Name -eq "AdventureWorks2019"}
$Schemas = $Database.Schemas
$Schemas
$Schemas.Script()

#Can we filter?
$Schemas = $Schemas | Where-Object {$_.Name -eq "Sales"}
$Schemas.Script()

#You can also do this on one line. Here's how you can filter AND call a method
$SalesSchema = $Database.Schemas | Where-Object {$_.Name -eq "Sales"}
$SalesSchema.Script()
#Same as
($Database.Schemas | Where-Object {$_.Name -eq "Sales"}).Script()

#Views
$Views = $Database.Views
$Views
$Views.Script()

#Wait, why so many

$Views = $Database.Views | Where-Object {$_.isSystemobject -eq $false}
$Views
$Views.Script()

#Schemabound?
$Views = $Database.Views
$Views = $Views | Where-object {$_.IsSchemaBound -eq $true}
$Views.Script()

#Procedures?
$Procs = $Database.StoredProcedures | Where-Object {$_.isSystemobject -eq $false}
$Procs.Script()


#What about indexes?
#Can't get it for a whole database... only objects that HAVE indexes
$Indexes = $Tables.Indexes
$Indexes = $Indexes += $Views.indexes
$Indexes.Script()

#Out to a .sql file?
$Indexes.Script() | Out-File C:\Lab\AW2019Indexes.sql

#Foreign Keys?
#this is where things get interesting...
$Tables.ForeignKeys


#Filter for one table
($Tables | Where-Object {$_.Schema -eq "Person" -and $_.Name -eq "Address"}).ForeignKeys | Out-GridView

#But how do we know what tables reference THIS table?
#We have methods
#First, let's just work with one table
$AddressTable = $Tables | Where-Object {$_.Schema -eq "Person" -and $_.Name -eq "Address"}
$AddressTable.EnumForeignKeys()

#So let's say I wanted to DROP the address table...
#I'd have to remove all FK's, right?
#Well we know what they are...
$KeysToDrop = $AddressTable.EnumForeignKeys()

ForEach ($k in $keystodrop) {
    $Key = $Tables.ForeignKeys | Where-Object {$_.Name -eq $k.Name}
    $Keyname = $Key.Name
    $Key.Script() | Out-File "C:\Lab\Key_$Keyname.sql"
    $Key.Drop()
}


#Database Users?
#It's easy to get database users...
$DatabaseUsers = $Database.users
$DatabaseUsers

#Now getting thier PERMISSIONS? That's a little trickier... or is it?
$Databaseusers.EnumRoles()

#Not very helpful if each user isn't a member
#Let's iterate!
ForEach ($u in $DatabaseUsers) {
    $u | Select-Object name, login, {$u.enumroles()}
}

#Now you can do some analysis!
$roleaudit = @()
ForEach ($u in $DatabaseUsers) {
    $roleaudit = $roleaudit + ($u | Select-Object name, login, @{Label="Roles";Expression={$u.enumroles()}})
}
$roleaudit | where-object {"db_owner" -in $_.Roles}

#Want to get object permissions?
#Sometimes, it's good work backwards...
$PersonSchemaObjects = $Database.Tables | Where-Object {$_.Schema -eq "Person"}
$ObjectPermissions = @()
ForEach ($o in $PersonSchemaObjects) {
    $ObjectPermissions = $ObjectPermissions + $o.EnumObjectPermissions()
}
$ObjectPermissions
$ObjectPermissions | Get-Member
$ObjectPermissions.PermissionType
$ObjectPermissions.PermissionType | Get-Member
$ObjectPermissions | Where-Object {$_.PermissionType.Update -eq $true}

#Demo 2
#Controlling scripting options
#You can use a Smo.Scripter object
#But we haven't done this before! Be brave...
$ScriptingServerObject = New-Object Microsoft.SqlServer.Management.Smo.Server("localhost")
$ScriptingOptions = New-Object Microsoft.SqlServer.Management.Smo.Scripter($ScriptingServerObject)

#Let's explore these objects a little bit
$ScriptingServerObject | get-member

$ScriptingOptions | get-member
$ScriptingOptions.Options
$ScriptingOptions.Options| get-member

#Now that we have the object, let's set some parameters for our scripter
$ScriptingOptions.options.IncludeIfNotExists 
$ScriptingOptions.options.IncludeIfNotExists = $true

#Calling our scripter works a little differently now, thought
$Tables = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\databases\adventureworks2019\tables
ForEach ($t in $Tables) {
    $ScriptingOptions.Script($t)
}

#We can do all sorts of things now!
$ScriptingOptions.options.DriPrimaryKey = $true
$ScriptingOptions.options.Permissions = $true
ForEach ($t in $Tables) {
    $ScriptingOptions.Script($t)
}

