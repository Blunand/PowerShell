Import-Module SQLSERVER

#Demo 1
#Browsing SQL Server Agent Jobs
cd SQLSERVER:\SQL\LocalHost\Default\JobServer
Get-ChildItem

#Explore!


#Demo 2
cd Jobs
Get-ChildItem
$jobs = Get-ChildItem

#What can we get/do?
$jobs | get-member

#As a for instance:
$jobs | Select-Object name, lastrundate, lastrunoutcome

#Macrosized:
$Jobs = @()
$Servers = @("localhost\default","someotherhost\default")
ForEach ($s in $servers) {
    $jobs = $jobs + (Get-Childitem -Path SQLSERVER:\SQL\$s\JobServer\Jobs)
}
$jobs | Select-Object OriginatingServer, name, lastrundate, lastrunoutcome

#can we disable jobs?
$jobs = Get-Childitem -Path SQLSERVER:\SQL\localhost\default\JobServer\Jobs
ForEach ($j in $jobs) {
    $j.IsEnabled = $false
}

#did that do it?
$jobs.Alter()

#Re-enable
$jobs = Get-Childitem -Path SQLSERVER:\SQL\localhost\default\JobServer\Jobs
ForEach ($j in $jobs) {
    $j.IsEnabled = $true
}
$jobs.Alter()

 
#Run a job
$FirstJob = Get-ChildItem | where-object {$_.Name -eq "PowerShell Job 1"}
$FirstJob
$FirstJob | Get-member
$FirstJob.Start()

#Enum jobs = enumerate
#Get all the job history
$FirstJob.EnumHistory()
$JobHistory = $FirstJob.EnumHistory()
$JobHistory | get-member


#Oh and we have cmdlets, just so you know
Get-SQLAgent
Get-SQLAgentJobHistory -ServerInstance localhost -JobName "PowerShell Job 1"

$Servers = ("localhost","localhost\namedinstance")
$Servers | Get-SQLAgentJobHistory

#Demo 3
#Copying Jobs
#No easy way to do this... but you can always script it!
$FirstJob.Script()
$FirstJob.Script() | Out-File C:\Lab\Scripted_SampleJob1.SQL
Invoke-SQLCmd -ServerInstance <some other instance> -Database msdb -InputFile "C:\Lab\Scripted_SampleJob1.SQL"

#What if I want to rename the job before I copy it?
#Time for some good ol' fashioned text find and replace
$FileContent = Get-Content -Path "C:\Lab\Scripted_SampleJob1.SQL"
$FileContent = $FileContent.Replace("'PowerShell Job 1'","'CopiedJob'")
$FileContent | Out-File "C:\Lab\Scripted_SampleJob1.SQL" -Force
Invoke-SQLCmd -ServerInstance localhost -Database msdb -InputFile "C:\Lab\Scripted_SampleJob1.SQL"

#Demo 3
#PowerShell Agent Jobs
#2017 and greater (2016?) - PowerShellJob_2016Greater.sql
#Cmdexec steps - PowerShellJob_OlderStyle.sql
#Job history - 
#Job results with errors? - PowerShellJob_CmdExecWithError.sql / PowerShellJob_ErrorActionExamples.sql
#Module loading with agent jobs? - PowerShellJob_WithModuleSupport.sql
