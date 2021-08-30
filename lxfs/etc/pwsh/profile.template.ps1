function Import-AzureModules() {
    Import-Module Az
    Import-Module Az.CosmosDB
}

$poshgit = Get-Module -Name posh-git -ListAvailable
if ($null -eq $poshgit) {
    $poshgit | Import-Module -Global
}

$ohmyposh = Get-Module -Name oh-my-posh -ListAvailable
if ($null -ne $ohmyposh) {
    $ohmyposh | Import-Module -Global
    Set-PoshPrompt -Theme powerlevel10k_rainbow
}

$az = Get-Module -Name Az -ListAvailable
if ($null -eq $az) {
    Write-Host -ForegroundColor Green "Az Modules available, run: 'Import-AzureModules'"
}
