OSH="/usr/local/share/bash/oh-my-bash";
ZSH="/usr/local/share/zsh/oh-my-zsh";

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
/bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mv -f /root/.oh-my-bash "${OSH}" 2>/dev/null;
mv -f /root/.oh-my-zsh "${ZSH}" 2>/dev/null;

pwsh -command 'Get-PSRepository | Set-PSRepository -InstallationPolicy Trusted; Install-Module oh-my-posh -Scope AllUsers -AcceptLicense -Force'

mkdir -p /opt/microsoft/powershell/7/
touch /opt/microsoft/powershell/7/profile.ps1
echo "Import-Module -Name oh-my-posh -Global;" >> /opt/microsoft/powershell/7/profile.ps1
echo "Set-PoshPrompt -Theme powerlevel10k_rainbow" >> /opt/microsoft/powershell/7/profile.ps1
