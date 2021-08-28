$module = Get-Module -Name oh-my-posh -ListAvailable
if ($null -ne $module) {
    Import-Module -Name oh-my-posh -Global
    Set-PoshPrompt -Theme powerlevel10k_rainbow
}
