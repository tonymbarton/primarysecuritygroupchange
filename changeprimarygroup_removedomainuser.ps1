$OUpath = 'OU=disabled,DC=example,DC=com'
$users = Get-ADUser -Filter * -SearchBase $OUpath -Properties SamAccountName
Foreach ($user in $users) {
    
    Add-ADGroupMember "disabled_users" -Members $user.samaccountname

    $group = Get-ADGroup "disabled_users"
    $groupsid = $group.sid
    $PrimaryGroupID = $groupsid.Value.Substring($groupsid.Value.LastIndexOf('-')+1)

    Set-ADUser -Identity $user.samaccountname -replace @{PrimaryGroupID=$PrimaryGroupID}

    Remove-ADGroupMember "Domain Users" -confirm:$false -member $user.samaccountname

    Write-Host -ForegroundColor Green "Complete."
    }