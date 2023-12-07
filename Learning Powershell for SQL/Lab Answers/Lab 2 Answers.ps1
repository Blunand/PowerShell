$procs = Get-Process

$procs | Out-File C:\Lab\ProcsExample.txt
$procs | Export-Csv C:\Lab\ProcsExample.csv
$procs | Out-GridView

Get-Process | Select-Object ProcessName, CPU | Out-File C:\lab\ProcsNameAndCPU.txt

Get-Help Get-Random

Get-Random -Minimum 0 -Maximum 2