#!/bin/bash
## postinstall
set -xv; exec 1>/Library/Application\ Support/JAMF/nessusConfig.txt 2>&1

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3


# Unlink the Nessus agent - Needed in case of upgrade or re-link…
# echo "########## UNLINKING NESSUS AGENT ##########" | logger
# sudo /Library/NessusAgent/run/sbin/nessuscli agent unlink | logger

installer -pkg /Users/Shared/Nessus/Install\ Nessus\ Agent.pkg -target / 

location="$(hostname | cut -c1-3 | tr '[:lower:]' '[:upper:]')"

echo "$location"

if [ $location = "WAU" ] || [ $location = "WAW" ]; then 
	
	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Wausau Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "WDC" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Wausau DC Workstations" --host=cloud.tenable.com --port=443 —-offline-install=yes

elif [ $location = "MLW" ]; then
	
	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Milwaukee Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "REC" ] || [ $location = "REK" ]; then 

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Recklinghausen Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "HJN" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Heijen Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes

elif [ $location = "TEA" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Team Edition Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes

elif [ $location = "BRD" ]; then 

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Bradenton Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "CHW" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Camp Hill Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes

elif [ $location = "CHI" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Chicago Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "VIA" ] || [ $location = "BRC" ] || [ $location = "DUB" ] || [ $location = "FRA" ] || [ $location = "LON" ] || [ $location = "PAR" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Vianen Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "BRI" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Brisbane Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "TRT" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Toronto Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "JCK" ]; then

/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Junction City Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes

elif [ $location = "HKG" ]; then

/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Hong Kong Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes

elif [ $location = "NYC" ] || [ $location = "NYO" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="New York Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
elif [ $location = "OSH" ]; then

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Oshkosh Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes
	
else

	/Library/NessusAgent/run/sbin/nessuscli agent link --key=8ec8ab0b679db1c00278d6090f46f780bc54ebc526fa4080048f9f5b5a47c22f --groups="Unassigned Workstations" --host=cloud.tenable.com --port=443 --offline-install=yes

fi

cd /library/NessusAgent/run/sbin and run 

./nessuscli fix --set update_hostname="yes"

sudo rm -rf /Users/Shared/Nessus

exit 0		## Success
exit 1		## Failure
