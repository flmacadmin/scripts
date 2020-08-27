#!/bin/sh

spctl --master-disable 

#system preferences
security authorizationdb write system.preferences allow
security authorizationdb write system.preferences.network allow
security authorizationdb write system.preferences.accessibility allow
security authorizationdb write system.preferences.energysaver allow
security authorizationdb write system.preferences.printing allow
security authorizationdb write system.preferences.datetime allow
security authorizationdb write system.preferences.timemachine allow
security authorizationdb write system.preferences.network allow
security authorizationdb write system.preferences.security allow
security authorizationdb write system.services.systemconfiguration.network allow


#Printing
security authorizationdb write system.preferences.printing allow
security authorizationdb write system.printingmanager allow
security authorizationdb write system.print.admin allow
security authorizationdb write system.print.operator allow

#Groups needed to be in for things to unlock
USERNAME=`who |grep console| awk '{print $1}'`

dseditgroup -o edit -a $USERNAME -T group lpadmin

/usr/libexec/airportd prefs RequireAdminNetworkChange=NO RequireAdminIBSS=NO

## Unload locationd
launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist

## Write enabled value to locationd plist
defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1
/usr/libexec/PlistBuddy -c "Set :com.apple.locationd.bundle-/System/Library/PrivateFrameworks/AssistantServices.framework:Authorized true" /var/db/locationd/clients.plist

## Reload locationd
launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

exit 0