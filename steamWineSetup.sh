#!/bin/bash

_steamwinepath=

_installCmd='apt-get install'
_installIfNotPresent()
{
	for p in $@; do
		if [[ $(hash $p) ]]; then sudo $_installCmd $p; fi
	done
}
_installIfNotPresent wine
_installIfNotPresent winetricks

sudo winetricks steam

### Create script in path to handle steam:// links with wine'd Steam
# Backup old file first
if [[ -e "/usr/bin/steam" ]]; then sudo mv "/usr/bin/steam" "/usr/bin/steam-BACKUP-$(date "+%y-%m-%d")"; fi
# make script
sudo bash -c 'echo -e "#!/bin/bash
# Steam wrapper script
exec wine \"c:\\program files\\steam\\steam.exe\" \"\$@\"" > /usr/bin/steam'

## Create .desktop file in /usr/share/applications
sudo bash -c "echo \"[Desktop Entry]
Encoding=UTF-8
Name=SteamWine
Type=Application
Exec=$_steamwinepath
Icon=Steam
StartupWMClass=Steam.exe
Categories=Game\" > /usr/share/applications/SteamWine.desktop"
