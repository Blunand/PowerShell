$job2 = Get-Childitem -Path SQLSERVER:\SQL\localhost\default\JobServer\Jobs | Where-Object {$_.Name -eq "Sample Job 2"}
$job2.IsEnabled = $false
$job2.Alter()

$Job2.Script()
$Job2.Script() | Out-File C:\Lab\Scripted_SampleJob2.SQL
Invoke-SQLCmd -ServerInstance localhost\NAMEDINSTANCE -Database msdb -InputFile "C:\Lab\Scripted_SampleJob2.SQL"

$NamedInstanceJob = Get-Childitem -Path SQLSERVER:\SQL\localhost\namedInstance\JobServer\Jobs | Where-Object {$_.Name -eq "Sample Job 2"}
$NamedInstanceJob.Start()

$InstanceJobs = Get-Childitem -Path SQLSERVER:\SQL\localhost\namedInstance\JobServer\Jobs 
$InstanceJobs | Select-Object name, lastrundate, lastrunoutcome


$Servers = ("localhost\default","localhost\namedinstance")
foreach ($s in $servers) {
    $jobs = Get-ChildItem -Path sqlserver:\sql\$s\jobserver\jobs
    $jobs | select-object name, lastrundate, OriginatingServer
}
