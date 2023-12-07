# Show how variables are created
$variable


#Let’s give it a value
$variable = 1



#Get the value
$variable



#Do something to a variable
$variable + 1



#Did nothing!
$variable = $variable + 1


#Numbers in PowerShell
$Variable = $variable + .5
$variable = $variable - .3
$variable = $variable * 5
$variable = $variable / 6


#Order of operations
#PEMDAS
$variable = 1
$variable = $variable + 1 * 4
$variable = ($variable + 1) * 4


#What about if I try to add letters?
$variable = $variable + 'Drew'


#But variables can just change
$variable = 'Drew'
$variable = $variable + 1
$variable


#Now can I "add" things?
$variable = $variable + "Brent"
$variable


#Strings and string literals
#Let’s use strings to build strings
$Number1 = 1
$Number10 = 10
$String = "I am thinking of a number between $Number1 and $Number10"
$String

$String = "This thing costs $12012 dollars"
$String

$String = 'This thing costs $12012 dollars'
$String

$String = 'I am thinking of a number between $Number1 and $Number10'
$String

$String = 'I am thinking of a number between ' + $Number1 + ' and ' + $Number10 + ' and if you guess it, you get $12012'
$String


#boolean
$booleanVariable = $true
$booleanVariable
$booleanVariable = $false
$booleanVariable


#Arrays!
#Declaring an array
$variable = @(1,2,3,4)


#Outputing an array
$variable


#Getting one array value
$variable[0]
$variable[2]
$variable[3]
$variable[10]

#Setting one array value
$variable[1] = "new value"
$variable



#Adding to an array
$variable = $variable + 'another new value'
$variable

#Can you subtract from any array?
$variable = $variable - 1


#Are there any restrictions on variable names?
#Some
#Boolean values
$true = 1
$false = 'Drew'
$true = $false

#How about starting with numbers?
$123 = 123
