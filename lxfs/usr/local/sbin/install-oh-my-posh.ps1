#!/usr/bin/env pwsh

Get-PSRepository -Name PSGallery |
    Where-Object -Property InstallationPolicy -NE -Value Trusted |
    Set-PSRepository -InstallationPolicy Trusted

Install-Module -Name posh-git -Scope AllUsers -AcceptLicense -Force
Install-Module -Name oh-my-posh -Scope AllUsers -AcceptLicense -Force
Install-Module -Name az -Scope AllUsers -AcceptLicense -AllowClobber -Force


$content = @"
`$module = Get-Module -Name oh-my-posh -ListAvailable
if (`$null -ne `$module) {
    Import-Module -Name posh-git -Global
    Import-Module -Name oh-my-posh -Global
    Set-PoshPrompt -Theme powerlevel10k_rainbow
}

Write-Output "Az Modules available: 'ipmo Az'"
"@

New-Item -Name $profile.CurrentUserCurrentUser -ItemType File -Force
New-Item -Name $profile.CurrentUserAllHosts -ItemType File -Force
New-Item -Name $profile.AllUsersCurrentHost -ItemType File -Force
New-Item -Name $profile.AllUsersAllHosts -ItemType File -Force
$content | Out-File $profile.AllUsersAllHosts -Force

New-Item -Name "/home/mssql/.config/powershell/Microsoft.PowerShell_profile.ps1" -ItemType File -Force
New-Item -Name "/home/mssql/.config/powershell/profile.ps1" -ItemType File -Force
