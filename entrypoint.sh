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

if [ "${ROCKET_AUTOUPDATE}" == "1" ]; then
    cd /home/container
    cp -r Extras/Rocket.Unturned Modules/
fi

if [ "${USCRIPT_AUTOUPDATE}" == "1" ]; then
    curl -s https://api.github.com/repos/GriffindorsDevelopment/unturned-egg-pterodactyl/releases/latest | jq -r ".assets[] | select(.name | contains(\"uScript.Unturned\")) | .browser_download_url" | wget -i -
	unzip -o -q uScript.Unturned*.zip -d Modules && rm uScript.Unturned*.zip
fi

mkdir -p Unturned_Headless_Data/Plugins/x86_64
cp -f steam/linux64/steamclient.so Unturned_Headless_Data/Plugins/x86_64/steamclient.so

ulimit -n 2048
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/Unturned_Headless_Data/Plugins/x86_64/

if [ "${LOGIN_TOKEN}" == "GSLToken Not Set" ]; then
    print 'game server token not set'
fi

MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}