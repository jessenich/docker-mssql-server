#!/usr/bin/env pwsh

[CmdletBinding()]
param (
    [Parameter()]
    [hashset]
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
    Set-PSRepository -InstallationPolicy Trusted -ErrorAction SilentlyContinue

foreach ($mod in $Modules) {
    if ($mod -imatch "[az]") {
        Install-Module -Name $mod -Scope AllUsers -Repository PSGallery -AcceptLicense -Force
    }
    else {
        Install-Module -Name $mod -Scope AllUsers -Repository PSGallery -AcceptLicense -Force
    }
}

$paths = @()
if ($LiteralPath.GetType() -eq [string].GetType() || $LiteralPath.Count -le 1) {
    $paths += $LiteralPath
}
elseif ($LiteralPath.Count -gt 1) {
    $paths = $LiteralPath;
}
else {
    $paths = @(
        $profile.CurrentUserCurrentHost,
        $profile.CurrentUserCurrentHost,
        $profile.AllUsersCurrentHost,
        $profile.AllUsersAllHosts,
        "/home/mssql/.config/powershell/Microsoft.PowerShell_profile.ps1",
        "/home/mssql/.config/powershell/profile.ps1"
    )
}

foreach ($pth in $paths) {
    if (!(Test-Path $pth)) {
        New-Item -Path $pth -ItemType File -Force
    }

    Set-Content -Path $pth -Value $Content -Force
}
