#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# If called with command line arguments, just exec a shell
if [ -n "$@" ]; then
    exec "$@"
fi

# Start up VNC server so we can run CrashPlanDesktop
rm -f /tmp/.X* 2>/dev/null
rm -f /tmp/.X11-unix/X* 2>/dev/null
rm -f /usr/spool/sockets/X11/* 2>/dev/null
rm -f /root/.vnc/docker-crashplan* 2>/dev/null
vncserver :0 -geometry 1280x1024 -xstartup /opt/crashplan/vnc_xstartup

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
    tail -F /opt/crashplan/log/*.0 /opt/crashplan/log/app.log /root/.vnc/*.log
    [ ${DONE} -eq 1 ] && exit
    sleep 1
done
