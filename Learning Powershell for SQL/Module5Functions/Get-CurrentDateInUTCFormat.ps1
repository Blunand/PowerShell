#A "file as a function"
#Part of module 5

[cmdletbinding()]
param ()

#Or, we could write a function
process {
    $UTCDate = Get-Date
    $UTCDate = $UTCDate.ToFileTimeUTC()
    $UTCDate
}