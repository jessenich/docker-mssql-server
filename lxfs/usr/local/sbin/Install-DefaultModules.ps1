#!/usr/bin/env pwsh

[CmdletBinding()]
param (
    [Parameter()]
    [hashset]
    $Modules = @("posh-git", "oh-my-posh", "Az", "Az.CosmosDB"),

    # Specifies a path to one or more locations. Unlike the Path parameter, the value of the LiteralPath parameter is
    # used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters,
    # enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any
    # characters as escape sequences.
    [Parameter(ValueFromPipelineByPropertyName=$true,
               HelpMessage="Literal path to one or more profile locations.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath = @(
        $profile.CurrentUserCurrentHost,
        $profile.CurrentUserCurrentHost,
        $profile.AllUsersCurrentHost,
        $profile.AllUsersAllHosts,
        "/home/mssql/.config/powershell/Microsoft.PowerShell_profile.ps1",
        "/home/mssql/.config/powershell/profile.ps1"
    ),

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
    $Content = Get-Content -Path "/etc/pwsh/profile.template.ps1"
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
$LiteralPathType = Get-Member -InputObject $Modules
if ($LiteralPathType.ToString() -eq "System.Object[]" || $LiteralPath.Count -le 0) {
    $paths = $LiteralPathType
}
elseif ($LiteralPathType -eq "System.String") {
    $paths += $LiteralPathType;
}

foreach ($path in $paths) {
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType File -Force
    }

    Set-Content -Path $path -Value $Content -Force
}
