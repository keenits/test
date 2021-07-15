#Script:   DisableComputers.ps1 
#Purpose:  To check AD for stale computer objects based on date logon criteria and disable / delete 
#Comments: Can be scheduled to run e.g. weekly to eleviate manual checks 
#Notes:   
 
$disabledays = (Get-Date).AddDays(-60) # The 365 is the number of days from today since the last logon. 
$deletedays = (Get-Date).AddDays(-180) 
 
# Disable computer objects and move to disabled OU (Older than 60 days): 
Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $disabledays} | Set-ADComputer -Enabled $false 
Get-ADComputer -Property Name,Enabled -Filter {Enabled -eq $False} | Move-ADObject -TargetPath "OU=Disabled Computers,DC=jmcontractors,DC=local" 
 
# Delete Older Disabled computer objects: 
# Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $deletedays} | Remove-ADComputer