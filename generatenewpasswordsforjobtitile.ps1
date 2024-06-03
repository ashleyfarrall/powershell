# Install the necessary modules if not already installed
# Install-Module -Name AzureAD
# Install-Module -Name MSOnline

# Connect to Azure AD and MSOnline
Connect-AzureAD
Connect-MsolService

# Function to generate a random password
function Generate-RandomPassword {
    $length = 12
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/`~"
    $password = -join (1..$length | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    return $password
}

# Function to convert a string to SecureString
function ConvertTo-SecureString {
    param (
        [string]$plainText
    )
    $secureString = New-Object System.Security.SecureString
    $plainText.ToCharArray() | ForEach-Object { $secureString.AppendChar($_) }
    return $secureString
}

# Get all users with the job title "Sales Floor Manager"
$users = Get-AzureADUser -All $true | Where-Object { $_.JobTitle -eq "Store Manager" }

# Array to hold user details for CSV export
$userDetails = @()

# Loop through each user and reset the password
foreach ($user in $users) {
    # Generate a new random password
    $newPassword = Generate-RandomPassword

    # Convert the password to a SecureString
    $securePassword = ConvertTo-SecureString -plainText $newPassword

    # Reset the password using Set-MsolUserPassword
    Set-MsolUserPassword -UserPrincipalName $user.UserPrincipalName -NewPassword $securePassword -ForceChangePassword $true

    # Collect user details and the new password for export
    $userDetails += [pscustomobject]@{
        DisplayName        = $user.DisplayName
        UserPrincipalName  = $user.UserPrincipalName
        JobTitle           = $user.JobTitle
        NewPassword        = $newPassword
    }
}

# Export user details to a CSV file
$userDetails | Export-Csv -Path "C:\salesfloor.csv" -NoTypeInformation
