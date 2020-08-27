#!/bin/bash

selection=$("/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType hud -lockHUD -title "Digital Guardian: Reboot Required" -heading "Please Read!" -icon "/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns" -description "We're improving your user experience! Foot Locker is migrating from Digital Guardian data loss prevention to Microsoft Advanced Information Protection. 

Please choose a number of minutes to delay this update and click restart, or if you're ready, click restart now. You will receive another pop-up window after the specified time, which will notify you the update is complete, and give you 1 minute to save your work before the restart occurs.

PLEASE be sure to SAVE your work before choosing a restart option!" -alignDescription left -button1 "Restart" -showDelayOptions "0, 600, 1800, 3600" -alignHeading left -timeout 7200)
buttonClicked="${selection:$i-1}"	
timeChosen="${selection%?}"

## Convert seconds to minutes for restart command
timeMinutes=$((timeChosen/60))

## Echoes for troubleshooting purposes
echo "Button clicked was: $buttonClicked"
echo "Time chosen was: $timeChosen"
echo "Time in minutes: $timeMinutes"

if [[ "$buttonClicked" == "1" ]] && [[ ! -z "$timeChosen" ]]; then
    echo "Restart button was clicked. Restarting in ${timeMinutes} minutes."
    sleep $timeChosen
    /usr/local/bin/jamf policy -trigger remove-digitalguardian
    echo "The policy is complete."
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -heading "Removal Complete" -icon "/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns" -alignHeading right -alignDescription right -description "The removal is complete. Your computer will restart in 1 minute to finish the removal process." -button1 "OK" -timeout 60 -countdown
    echo "Shutting down."
    shutdown -r +1
	exit 0
	
else [[ "$buttonClicked" == "1" ]] && [[ -z "$timeChosen" ]];
    echo "Restart button was clicked. Initiating immediate restart."
     /usr/local/bin/jamf policy -trigger remove-digitalguardian
    echo "The policy is complete."
    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -heading "Removal Complete" -icon "/Library/Application Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns" -alignHeading right -alignDescription right -description "The removal is complete. Your computer will restart in 1 minute to finish the removal process." -button1 "OK" -timeout 60 -countdown
    echo "Shutting down."
    shutdown -r +1
	exit 0
fi
