# Connect to Azure AD
Connect-AzureAD

# Define the security group
$groupId = "535f39a4-283b-42e7-990f-ebb0a7ef0246" # Replace with your Security Group Object Id

# Get all members of the security group
$groupMembers = Get-AzureADGroupMember -ObjectId $groupId -All $true

# Filter out disabled users
$enabledUsers = $groupMembers | Where-Object { $_.AccountEnabled -eq $true }

# Display the enabled users
$enabledUsers | Select-Object DisplayName, UserPrincipalName, AccountEnabled

Write-Output "Enabled users in the security group have been listed."