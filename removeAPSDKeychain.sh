#!/bin/sh

if [[ -e /Library/Keychains/apsd.keychain ]]; then
    ExpDate=$(/usr/bin/security find-certificate -a -p -Z /Library/Keychains/apsd.keychain | /usr/bin/openssl x509 -noout -enddate| cut -f2 -d=)
    EpochOne=$(date -j -f '%b %d %T %Y %Z' "$ExpDate" '+%s')
    EpochTwo=$(date +%s)
    MathOne=$(($EpochOne - $EpochTwo))
    MathTwo=$(($MathOne / 86400))
    #days=$(echo ${MathTwo//-})
    /usr/bin/logger -s "Enrollment Cert expires on $ExpDate which is $MathTwo days away"
    if [[ $MathTwo == *"-"* ]]; then
      DEPcert=$(/usr/bin/security find-certificate -a -Z /Library/Keychains/apsd.keychain | grep SHA-1 | awk '{print $3}')
      /usr/bin/logger -s "Cert is $MathTwo days old, deleting cert" 
      /usr/bin/security delete-certificate -Z "$DEPcert" /Library/Keychains/apsd.keychain
    else
      /usr/bin/logger -s "Cert is less than a year old"
    fi
fi

exit 0