#!/bin/bash
####################################################################################################
#
# Copyright (c) 2013, JAMF Software, LLC.  All rights reserved.
#
#       This script was written by the JAMF Software Profesional Services Team
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#####################################################################################################
#
# SUPPORT FOR THIS PROGRAM
#
#       This program is distributed "as is" by JAMF Software, Professional Services Team. For more
#       information or support for this script, please contact your JAMF Software Account Manager.
#
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   jamfHelperByPolicy.sh
#
# SYNOPSIS - How to use
#   Run via a policy to populate JAMF Helper with values to present messages to the user.
#
# DESCRIPTION
#
#   Populate script parameters to match the variables below.
#   Pass in values into these parameters during a policy.
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.0
#
#   - Created by Douglas Worley, Professional Services Engineer, JAMF Software on May 10, 2013
#
####################################################################################################
# The recursively named JAMF Helper help file is accessible at:
# /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -help

windowType="hud"         #   [hud | utility | fs]
windowPosition="" #   [ul | ll | ur | lr]
title="Foot Locker, Inc."          #   "string"
heading="Migrate to Jamf Cloud"            #   "string"
description="Please select a convenient time to complete the Jamf Cloud migration. A log out will be required once the migration is complete."        #   "string"
icon="/Applications/Self Service.app/Contents/Resources/AppIcon.icns"               #   path
iconSize=""           #   pixels
timeout="3600"            #   seconds


[ "$4" != "" ] && [ "$windowType" == "" ] && windowType=$4
[ "$5" != "" ] && [ "$windowPosition" == "" ] && windowPosition=$5
[ "$6" != "" ] && [ "$title" == "" ] && title=$6
[ "$7" != "" ] && [ "$heading" == "" ] && heading=$7
[ "$8" != "" ] && [ "$description" == "" ] && description=$8
[ "$9" != "" ] && [ "$icon" == "" ] && icon=$9
[ "$10" != "" ] && [ "$iconSize" == "" ] && iconSize=$10
[ "$11" != "" ] && [ "$timeout" == "" ] && timeout=$11

function setSnooze ()
{

## Get the time right now in Unix seconds
timeNow=$(date +"%s")
## Calculate the time for the next available display of the prompt (adds the time now and time chosen together in seconds)
timeNextRun=$((timeNow+SnoozeVal))

## Create or update a plist value containing the above next time to run value
/usr/bin/defaults write /Library/Preferences/com.acme.policy_001.snooze.plist DelayUntil -int $timeNextRun

exit 0

}

function showPrompt ()
{

## Prompt, and capture the output
HELPER=$("/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfhelper" -windowType "$windowType" -windowPosition "$windowPosition" -title "$title" -heading "$heading" -description "$description"  -icon "$icon" -iconSize "$iconSize" -button1 Migrate Now” -button2 Snooze -defaultButton 2 -cancelButton "2" -countdown "$timeout" -timeout "$timeout" -showDelayOptions "900, 1800, 14400, 43200, 86400")

echo "jamf helper result was $HELPER"

## Dissect the response to get just the button clicked and the value selected from the drop down menu
ButtonClicked="${HELPER: -1}"
SnoozeVal="${HELPER%?}"

echo "$ButtonClicked"
echo "$SnoozeVal"

if [ "$ButtonClicked" == "1" ]; then
    echo "User chose Install"
    /usr/local/bin/jamf policy -trigger migratejamfcloud
    exit 0
elif [ "$ButtonClicked" == "2" ]; then
    echo "User chose Snooze"
    setSnooze
fi

}

## Get a value (if possible) from a plist of the next valid time we can prompt the user
SnoozeValueSet=$(/usr/bin/defaults read /Library/Preferences/com.acme.policy_001.snooze.plist DelayUntil 2>/dev/null)

## If we got something from the plist...
if [ -n "$SnoozeValueSet" ]; then
    ## See what time it is now, and compare it to the value in the plist.
    ## If the time now is greater or equal to the value in the plist, enough time has elapsed, so...
    timeNow=$(date +"%s")
    if [[ "$timeNow" -ge "$SnoozeValueSet" ]]; then
        ## Display the prompt to the user again
        showPrompt
    else
        ## If the time now is less than the value in the plist, exit
        echo "Not enough time has elapsed. Exiting..."
        exit 0
    fi
else
    ## If no value was in the plist or the plist wasn't there, assume it is the first run of the script and prompt them
    showPrompt
fi