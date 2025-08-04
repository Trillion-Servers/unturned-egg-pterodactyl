#!/bin/bash
sleep 1

cd /home/container

# Fix SteamCMD Warnings
if [ ! -f "./steam/linux32/steamservice.so" ]; then
    cd /home/container/steam/linux32
    cp steamclient.so steamservice.so
    cp steamclient.so libSDL3.so.0
    echo "SteamCMD Fix Deployed"
    cd /home/container
fi

if [ "${GAME_AUTOUPDATE}" == "1" ]; then
    ./steam/steamcmd.sh +@sSteamCmdForcePlatformBitness 64 +force_install_dir /home/container +login anonymous +app_update 1110390 +quit
fi

if [ "${OPENMOD_AUTOUPDATE}" == "1" ]; then
    curl -s https://api.github.com/repos/openmod/OpenMod/releases/latest | jq -r ".assets[] | select(.name | contains(\"OpenMod.Unturned.Module\")) | .browser_download_url" | wget -i -
	unzip -o -q OpenMod.Unturned.Module*.zip -d Modules && rm OpenMod.Unturned.Module*.zip
fi

if [ "${ROCKET_AUTOUPDATE}" == "1" ]; then
    cd /home/container
    cp -r Extras/Rocket.Unturned Modules/
fi

mkdir -p Unturned_Headless_Data/Plugins/x86_64
cp -f steam/linux64/steamclient.so Unturned_Headless_Data/Plugins/x86_64/steamclient.so

ulimit -n 2048
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/Unturned_Headless_Data/Plugins/x86_64/



MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}
