#!/usr/bin/env pwsh

[CmdletBinding()]
param (
    [Parameter()]
    [string[]]
    $Modules = @("posh-git", "oh-my-posh", "Az"),

    # Specifies a path to one or more locations. Unlike the Path parameter, the value of the LiteralPath parameter is
    # used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters,
    # enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
    # characters as escape sequences.
    [Parameter(ValueFromPipelineByPropertyName=$true,
               HelpMessage="Literal path to one or more profile locations.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath = @($profile.AllUsersAllHosts),

    # Working directory to execute script within
    [Parameter()]
    [string]
    $WorkingDirectory = $PWD,

    # Override default content written to profile locations
    [Parameter()]
    [string]
    $Content = $null
)

if ($null -eq $Content) {
    $content = @"
`$module = Get-Module -Name oh-my-posh -ListAvailable
if (`$null -ne `$module) {
    Import-Module -Name posh-git -Global
    Import-Module -Name oh-my-posh -Global
    Set-PoshPrompt -Theme powerlevel10k_rainbow
}

Write-Output "Az Modules available: 'ipmo Az'"
"@
}


Get-PSRepository -Name PSGallery |
    Where-Object -Property InstallationPolicy -NE -Value Trusted |
    Set-PSRepository -InstallationPolicy Trusted

foreach ($mod in $modules) {
    $HashArgs = @{
        Name = $mod
        Scope = AllUsers
        AcceptLicense = $true
    };

    if ($mod -eq "Az") {
        $HashArgs.AllowClobber = $true;
    }

    Install-Module @HashArgs
}
$paths = @()
if ($LiteralPath.GetType() -eq [string].GetType()) {
    $paths += $LiteralPath
}

New-Item -Name $profile.CurrentUserCurrentUser -ItemType File -Force
New-Item -Name $profile.CurrentUserAllHosts -ItemType File -Force
New-Item -Name $profile.AllUsersCurrentHost -ItemType File -Force
New-Item -Name $profile.AllUsersAllHosts -ItemType File -Force
New-Item -Name "/home/mssql/.config/powershell/Microsoft.PowerShell_profile.ps1" -ItemType File -Force
New-Item -Name "/home/mssql/.config/powershell/profile.ps1" -ItemType File -Force

foreach ($p in $paths) {
    if (!(Test-Path $p)) {
        New-Item -Path $p -ItemType File -Force
    }

    Set-Content -Path $p -Value $Content -Force
}
