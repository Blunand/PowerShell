$DBUsers = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\databases\AdventureWorks2014_Production\Users | Where-Object {$_.LoginType -eq "WindowsUser"}
$list = @()
Foreach ($d in $DBUsers){
       $name = $d.name.replace("LAB\","")
       $filter = 'samaccountName -eq "' + $name + '"'
       $list += Get-ADUser -Filter $filter -Properties * | Select-Object samaccountname, surname, lastlogondate, MemberOf
}
$list

#Here's the modified function from the example, with all the additions: turned into a function and including role membership
function Get-DatabasePermissions {
    param (
        [Parameter(Mandatory=$true)] [string] $instance,
        [Parameter(Mandatory=$false)] [string] $databasename
    )
    $PermissionsAudit = @()
    $Databases = Get-ChildItem -Path SQLSERVER:\SQL\$instance\databases
    if ($databasename) {
        $Databases = $Databases | Where-Object {$_.Name -eq $DatabaseName}
    }
    #$Database = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\databases | Where-Object {$_.Name -eq "AdventureWorks2014_Production"}
    ForEach ($db in $Databases) {
        $DatabaseGroups = $db.Users | Where-Object {$_.LoginType -eq "WindowsGroup"}
        $currentDatabase = $db.Name
        Write-Verbose $currentDatabase
        #$Database
        #$DatabaseGroups

        $DatabasePermissions = $db.EnumObjectPermissions()

        ForEach ($WindowsGroups in $DatabaseGroups) {
            $Roles = $WindowsGroups.EnumRoles()
            $GroupMembers = Get-ADGroupMember $WindowsGroups.name.replace("LAB\","") -Recursive

            ForEach ($Member in $GroupMembers) {
                $ThisUsersPermissions = $DatabasePermissions | Where-Object {$_.Grantee -eq $WindowsGroups.Name}

                ForEach ($p in $ThisUsersPermissions) {

                    if ($p.ObjectClass -eq "Schema") {
                        $ObjectName = $p.ObjectName
                    } else {
                        $ObjectName = $p.ObjectSchema + "." + $p.ObjectName
                    }

                    $Permission = [PSCustomObject] @{
                        database = $db.Name
                        GroupName = $WindowsGroups.Name
                        GroupMember = $Member.Name
                        ObjectType = $p.ObjectClass
                        Permissions = $p.PermissionType.ToString()
                        ObjectName = $ObjectName
                        MemberOf = $Roles
                    }

                    $PermissionsAudit = $PermissionsAudit + $Permission
                }
            }
        }
    }
    $PermissionsAudit
}
