#!/bin/sh
## postinstall

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3

# Teamviewer postinstall script. Configures settings and assigns the host to Foot Locker's workstations group.
# Written by Kyle Burns.
# Last Modified 3/18/2021

# Configure TeamViewer settings before TeamViewer install
defaults write com.teamviewer.teamviewer.prefences AddOnChannels -integer 7
defaults write com.teamviewer.teamviewer.prefences Always_Online -integer 1
defaults write com.teamviewer.teamviewer.prefences AutoUpdateChannel -integer 1
defaults write com.teamviewer.teamviewer.prefences AutoUpdateMode -integer 2
defaults write com.teamviewer.teamviewer.prefences AutoUpdateServerURL -string "https://download.teamviewer.com/download/update/macupdates.xml"
defaults write com.teamviewer.teamviewer.prefences Security_Adminrights -integer 1
defaults write com.teamviewer.teamviewer.prefences UpdateCheckInterval -integer -1

# Install the teamviewer host app
sudo installer -applyChoiceChangesXML /private/tmp/TeamViewer/choices.xml -pkg "/private/tmp/TeamViewer/Install TeamViewerHost-idca3jmzga".pkg -target / 

# Wait
sleep 10

# Open the host app so the service starts
open /Applications/TeamViewerHost.app

# Assign to the workstations group ID
APITOKEN=2648469-08OTmEmSAApPdNAOIVQE
GROUPID=g127819087
while true; do
    process=$(ps aux | grep TeamViewerHost | grep -v grep | wc -l)
        echo "Process: $process"
    if [ $process -gt 2 ]; then
        echo "Assigning..."
        sleep 20
                /Applications/TeamViewerHost.app/Contents/Helpers/TeamViewer_Assignment -api-token $APITOKEN -group-id $GROUPID -alias "$(hostname -s)" -grant-easy-access -reassign
        exit $?
    else
        echo "Waiting for TeamViewer to start..."
        sleep 20
    fi
done

exit 0		## Success
exit 1		## Failure
