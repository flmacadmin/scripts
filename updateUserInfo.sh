#!/bin/bash

# Get currently logged in user
loggedInUser="$(ls -l /dev/console | awk '{print $3}')"

echo "$loggedInUser"

# Get logged in users's username
userName=`/usr/bin/dscl . read /Users/$loggedInUser RecordName | awk '{ print $2 }'`

echo "$userName"

# Get user's full name
fullName=`dscl . -read /Users/$loggedInUser | awk '/^RealName:/,/^RecordName:/' | sed -n 2p | cut -c 2-`

echo "$fullName"

jamf recon -endUsername "$userName"
jamf recon -realname "$fullName"
