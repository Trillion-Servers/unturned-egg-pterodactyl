#!/bin/bash
sleep 1

cd /home/container

./steam/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 1110390 +quit

if [ "${GAME_AUTOUPDATE}" == "1" ]; then
    ./steam/steamcmd.sh +@sSteamCmdForcePlatformBitness 64 +login anonymous +force_install_dir /home/container +app_update 1110390 +quit
fi

if [ "${OPENMOD_AUTOUPDATE}" == "1" ]; then
    curl -s https://api.github.com/repos/openmod/OpenMod/releases/latest | jq -r ".assets[] | select(.name | contains(\"OpenMod.Unturned.Module\")) | .browser_download_url" | wget -i -
	unzip -o -q OpenMod.Unturned.Module*.zip -d Modules && rm OpenMod.Unturned.Module*.zip
fi

if [ "${OPENMOD_ROCKETMOD}" == "1" ]; then
    curl -s https://api.github.com/repos/openmod/OpenMod.Installer.RocketMod/releases/latest | jq -r ".assets[] | select(.name | contains(\"OpenMod.Installer.RocketMod-v1.0.0-beta3.dll\")) | .browser_download_url" | wget -i -
	cd /Servers/unturned/Rocket/plugins/
    rm OpenMod.Installer.RocketMod-v1.0.0-beta3.dll
fi

if [ "${ROCKET_AUTOUPDATE}" == "1" ]; then
    cp -r Extras/Rocket.Unturned Modules/
fi

cp -f steam/linux64/steamclient.so Unturned_Headless_Data/Plugins/x86_64/steamclient.so

ulimit -n 2048
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/Unturned_Headless_Data/Plugins/x86_64/

MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}
