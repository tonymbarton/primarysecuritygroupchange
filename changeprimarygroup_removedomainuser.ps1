$OUpath = 'OU=Extranet,DC=wagmanblue,DC=com'
$users = Get-ADUser -Filter * -SearchBase $OUpath -Properties SamAccountName
Foreach ($user in $users) {
    
    Add-ADGroupMember "s_noaccess" -Members $user.samaccountname

    $group = Get-ADGroup "s_noaccess"
    $groupsid = $group.sid
    $PrimaryGroupID = $groupsid.Value.Substring($groupsid.Value.LastIndexOf('-')+1)

    Set-ADUser -Identity $user.samaccountname -replace @{PrimaryGroupID=$PrimaryGroupID}

    Remove-ADGroupMember "Domain Users" -confirm:$false -member $user.samaccountname

    Write-Host -ForegroundColor Green "Complete."
    }