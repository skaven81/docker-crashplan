#!/bin/bash

PATH=/usr/bin:/usr/sbin:/bin:/sbin

# Ensure we can connect to the console remotely without
# needing an SSH tunnel
sed -i -e 's~serviceHost>[0-9\.locahst]*<~serviceHost>0.0.0.0<~' /opt/crashplan/conf/my.service.xml

/opt/crashplan/jre/bin/java \
        -Dfile.encoding=UTF-8 \
        -Dapp=CrashPlanService \
        -DappBaseName=CrashPlan \
        -Xms20m -Xmx1024m \
        -Dsun.net.inetaddr.ttl=300 \
        -Dnetworkaddress.cache.ttl=300 \
        -Dsun.net.inetaddr.negative.ttl=0 \
        -Dnetworkaddress.cache.negative.ttl=0 \
        -Dc42.native.md5.enabled=false \
        -classpath /opt/crashplan/lib/com.backup42.desktop.jar:/opt/crashplan/lang\
        com.backup42.service.CPService &

if [ ! -f /var/lib/crashplan/.ui_info ]; then
    while true; do
        sleep 1
        [ -f /var/lib/crashplan/.ui_info ] && break
        echo "Waiting for /var/lib/crashplan/.ui_info to appear"
    done
else
    sleep 10
fi

DONE=0
trap "DONE=1" INT
while true; do
    echo "***** IP INFO *****"
    ifconfig eth0
    echo "***** UI INFO *****"
    cat /var/lib/crashplan/.ui_info
    echo
    sleep 600
    [ ${DONE} -eq 1 ] && exit
done
