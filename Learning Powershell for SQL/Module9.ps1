Import-Module SQLSERVER

#Setup: Make sure you have the RSAT tools installed!
#PowerShell As Administrator: 
#Get-WindowsCapability -Name RSAT* -Online
#Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
#More information: https://learn.microsoft.com/en-US/troubleshoot/windows-server/system-management-components/remote-server-administration-tools

#Demo 1
#Let's revisit our permissions auditing
#First let's get all our database users

$DatabaseUsers = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\databases\AdventureWorks2019\Users
$DatabaseUsers

$DatabaseUsers | Get-Member

#Hmm, what's this?
$DatabaseUsers | Select-Object Name, Login, UserType, LoginType

#Well, we know about the SQL Login, but there's Drew, and there's some groups
#We know how to audit Drew's rights
$DatabaseUsers[0].EnumRoles()


#But what if we want to know where Drew works, or more information from Active Directory?
#Let's uh, use more PowerShell!
#There's an entire module dedicated to Active Directory
Import-Module ActiveDirectory

#Returns everything, filter is *required*
Get-ADUser -Filter *

#What's the best way to narrow our results?
#Filter the way the cmdlet wants...
Get-ADUser -Filter 'samaccountname -eq "drew"'

#Or filter the way we always have
Get-ADUser -Filter * | Where-Object {$_.SamAccountName -eq "Drew"}

#What's better?

#Check out all the stuff we can learn about me!
$Drew = Get-ADUser -Filter 'samaccountname -eq "drew"'
$Drew | Get-Member
$Drew | Select-Object Name, GivenName, SurName, SamAccountName, Enabled

#But wait there's more!
$Drew = Get-ADUser -Filter 'samaccountname -eq "drew"' -Properties *
$Drew | get-member
$Drew | Select-Object Name, GivenName, SurName, SamAccountName, Enabled, Department
#What about AD Groups
$Groups = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\databases\AdventureWorks2019\users | Where-Object {$_.LoginType -eq "WindowsGroup"}

#Check out the group names...
$Groups.Name
ForEach ($g in $groups) {
    Get-ADGroupMember $g.name -Recursive
}
#We can't just query that... so we need to trim out the domain name...

$Groups.Name.Replace("PWSHDEMO\","")

ForEach ($g in $groups) {
        Get-ADGroupMember $g.name.replace("PWSHDEMO\","") -Recursive
}


#Demo 2
#Tying it all together!
#That's great and all, but we now need to match up the group permssions to the group members... how?
#Let's create a custom object to hold our results
$Database = Get-ChildItem -Path SQLSERVER:\SQL\localhost\default\databases | Where-Object {$_.Name -eq "AdventureWorks2019"}
$DatabaseGroups = $Database.Users | Where-Object {$_.LoginType -eq "WindowsGroup"}

$Database
$DatabaseGroups

$DatabasePermissions = $Database.EnumObjectPermissions()

$PermissionsAudit = @()

ForEach ($WindowsGroups in $DatabaseGroups) {
    $GroupMembers = Get-ADGroupMember $WindowsGroups.name.replace("PWSHDEMO\","") -Recursive

    ForEach ($Member in $GroupMembers) {
        $ThisUsersPermissions = $DatabasePermissions | Where-Object {$_.Grantee -eq $WindowsGroups.Name}

        ForEach ($p in $ThisUsersPermissions) {

            if ($p.ObjectClass -eq "Schema") {
                $ObjectName = $p.ObjectName
            } else {
                $ObjectName = $p.ObjectSchema + "." + $p.ObjectName
            }

            $Permission = [PSCustomObject] @{
                GroupName = $WindowsGroups.Name
                GroupMember = $Member.Name
                ObjectType = $p.ObjectClass
                Permissions = $p.PermissionType.ToString()
                ObjectName = $ObjectName
            }

            $PermissionsAudit = $PermissionsAudit + $Permission
        }
    }
}
$PermissionsAudit

$PermissionsAudit | Export-CSV -Path C:\Lab\AuditReport.csv