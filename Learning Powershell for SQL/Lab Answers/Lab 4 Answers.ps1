#Select the first 100 files, sorted by 
$First100 = Get-ChildItem -Path E:\JunkFiles | Sort-Object -Property CreationTime | Select-Object -first 100

#Now that we have those files, we can pass them via pipeline to Remove-Item (-Whatif will not delete them, just what they WOULD be)
$first100 | remove-item -WhatIf

$Files = Get-ChildItem -Path E:\JunkFiles
$Files | Sort-Object -Property CreationTime |Select-Object -First 100 | Remove-Item -WhatIf

#With those gone, get a new (refrshed) file listing of files with yellow in the name
$JunkFiles = Get-ChildItem -Path E:\JunkFiles | Where-Object {$_.Name -like "*yellow*"}

#Now loop through each one, get the current extension, and rename them with Rename-Item replacing the current extension with .99
ForEach ($j in $JunkFiles) {
    $Extension = $j.Extension
    Rename-Item -Path $j.FullName -NewName $j.FullName.Replace($Extension,".99") -WhatIf
}

#Now let's get all the imagism files, get their content, and append it all to a new file
$JunkFiles = Get-ChildItem -Path E:\JunkFiles | Where-Object {$_.Name -like "*white*"}
ForEach ($j in $JunkFiles) {
    Get-Content $j.FullName | Out-File C:\lab\junkfiles.txt -Append
}

#Bonus question: restarting a service
Get-Service | Where-Object {$_.Name -like "MSSQLSERVER"} | Restart-Service