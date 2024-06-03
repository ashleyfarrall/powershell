# Import the Active Directory module
Import-Module ActiveDirectory

# Define the date three months ago
$threeMonthsAgo = (Get-Date).AddMonths(-12)

# Search for user accounts with the specific conditions
$users = Get-ADUser -Filter {Enabled -eq $false -or LastLogonDate -lt $threeMonthsAgo} -Properties Description, whenChanged, LastLogonDate

# Filter users who meet the criteria:
# - Disabled for more than three months
# - Last logon more than three months ago
# - Description equals "Account Decommissioned"
$filteredUsers = $users | Where-Object {
    ($_.whenChanged -lt $threeMonthsAgo -or $_.LastLogonDate -lt $threeMonthsAgo) -and $_.Description -eq "Account Decommissioned"
}

# Output the results
$filteredUsers | Select-Object Name, SamAccountName, whenChanged, LastLogonDate, Description | Format-Table -AutoSize

# Confirm before deletion
$confirm = Read-Host "Do you want to delete these accounts? Type 'Yes' to confirm"

if ($confirm -eq 'Yes') {
    # Delete the accounts
    $filteredUsers | ForEach-Object {
        Remove-ADUser -Identity $_ -Confirm:$false
        Write-Host "Deleted user:" $_.SamAccountName
    }
} else {
    Write-Host "Deletion canceled."
}
