FROM centos:7

MAINTAINER Paul Krizak <paul.krizak@gmail.com>

VOLUME [ "/var/lib/crashplan", "/opt/crashplan/conf", "/opt/crashplan/cache", "/crashplan-store" ]

WORKDIR /

RUN /usr/bin/yum -y --nogpgcheck install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    /usr/bin/yum -y --nogpgcheck install which wget expect net-tools libXScrnSaver tigervnc tigervnc-server \
        fluxbox xterm gtk2 GConf2 alsa-lib google-noto-sans-fonts

EXPOSE 5900

RUN [ "/usr/bin/wget", "https://web-ham-msp.crashplanpro.com/client/installers/CrashPlanSmb_6.7.2_1512021600672_5609_Linux.tgz", "-O", "crashplan.tgz" ]

RUN [ "/usr/bin/tar", "-xzf", "crashplan.tgz" ]

RUN [ "/bin/rm", "-f", "*.tgz" ]

WORKDIR /crashplan-install

COPY [ "install.expect", "install.expect" ]

RUN [ "./install.expect" ]

WORKDIR /opt/crashplan

RUN mkdir -p /root/.vnc; \
    echo "crashplan" | vncpasswd -f > /root/.vnc/passwd; \
    chmod 600 /root/.vnc/passwd

COPY [ "vnc_xstartup", "vnc_xstartup" ]
COPY [ "run_crashplan.sh", "run_crashplan.sh" ]

ENTRYPOINT [ "/opt/crashplan/run_crashplan.sh" ]

