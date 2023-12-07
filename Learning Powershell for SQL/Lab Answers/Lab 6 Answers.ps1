#Get all the databases on a server
$dbs = get-childitem -path sqlserver:\sql\localhost\default\databases -Force

#Set each offline
foreach ($d in $dbs) {
    $d.SetOffline()
}

$dbs.Setoffline()

#Or, set them offline with one line
$dbs.SetOffline()

#Set them all online
$dbs.SetOnline()

#Get all the table triggers
$tables = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2014\tables
$triggers = $tables.triggers

#Disable the triggers
foreach ($t in $triggers) {
    $t.IsEnabled = $false
    $t.Alter()
}

$views = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2014\views
$views | where-object {$_.IsSchemabound -eq $true}
$views | where-object {$_.IsSchemabound}

$tables = get-childitem -path sqlserver:\sql\localhost\default\databases\adventureworks2014\tables

#Multiple servers
$Servers = @("localhost\default","localhost\namedinstance")
foreach ($s in $servers) {
    get-childitem -path sqlserver:\sql\$s\databases\adventureworks2014\tables   
}

