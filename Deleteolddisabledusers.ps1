# Import the Active Directory module
Import-Module ActiveDirectory
# Import the Active Directory module
Import-Module ActiveDirectory

# Define the date X months ago
$MonthsAgo = (Get-Date).AddMonths(-6)

# Search for all disabled user accounts
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties whenChanged

# Filter users who have been disabled for more than three months
$disabledForMoreThanThreeMonths = $disabledUsers | Where-Object { $_.whenChanged -lt $MonthsAgo }

# Output the results
$disabledForMoreThanThreeMonths | Select-Object Name, SamAccountName, whenChanged | Format-Table -AutoSize

# Confirm before deletion
$confirm = Read-Host "Do you want to delete these accounts? Type 'Yes' to confirm"

if ($confirm -eq 'Yes') {
    # Delete the accounts
    $disabledForMoreThanThreeMonths | ForEach-Object {
        Remove-ADUser -Identity $_ -Confirm:$false
        Write-Host "Deleted user:" $_.SamAccountName
    }
} else {
    Write-Host "Deletion canceled."
}

