FROM centos:7

MAINTAINER Paul Krizak <paul.krizak@gmail.com>

VOLUME [ "/var/lib/crashplan", "/opt/crashplan/conf", "/opt/crashplan/cache", "/crashplan-store" ]

WORKDIR /

RUN /usr/bin/yum -y --nogpgcheck install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    /usr/bin/yum -y --nogpgcheck install which wget expect net-tools libXScrnSaver tigervnc tigervnc-server \
        fluxbox xterm gtk2 GConf2 alsa-lib google-noto-sans-fonts gtk3 xorg-x11-fonts-*

EXPOSE 5900

RUN [ "/usr/bin/wget", "https://www.crashplanpro.com/client/installers/CrashPlanSmb_6.8.3_1525200006683_951_Linux.tgz", "-O", "crashplan.tgz" ]

RUN [ "/usr/bin/tar", "-xzf", "crashplan.tgz" ]

RUN [ "/bin/rm", "-f", "*.tgz" ]

WORKDIR /crashplan-install

COPY [ "install.expect", "install.expect" ]

RUN [ "./install.expect" ]

WORKDIR /opt/crashplan

RUN mkdir -p /root/.vnc; \
    echo "crashplan" | vncpasswd -f > /root/.vnc/passwd; \
    chmod 600 /root/.vnc/passwd

# electron requires a D-Bus machine ID to run,
# and I suspect that this is also how the GUID
# is generated/checked.
RUN echo 8a5374d927a6d7bcc970e1715b3929db > /var/lib/dbus/machine-id


COPY [ "vnc_xstartup", "vnc_xstartup" ]
COPY [ "run_crashplan.sh", "run_crashplan.sh" ]

ENTRYPOINT [ "/opt/crashplan/run_crashplan.sh" ]

