FROM centos:7

MAINTAINER Paul Krizak <paul.krizak@gmail.com>

VOLUME [ "/var/lib/crashplan", "/opt/crashplan/conf", "/opt/crashplan/cache", "/crashplan-store" ]

WORKDIR /

RUN [ "/usr/bin/yum", "-y", "--nogpgcheck", "install", "which", "wget", "expect", "net-tools", "libXScrnSaver" ]

RUN [ "/usr/bin/wget", "https://web-eam-msp.crashplanpro.com/client/installers/CrashPlanSmb_6.7.1_1512021600671_4615_Linux.tgz", "-O", "crashplan.tgz" ]

RUN [ "/usr/bin/tar", "-xzf", "crashplan.tgz" ]

RUN [ "/bin/rm", "-f", "*.tgz" ]

WORKDIR /crashplan-install

COPY [ "install.expect", "install.expect" ]

RUN [ "./install.expect" ]

WORKDIR /opt/crashplan

COPY [ "run_crashplan.sh", "run_crashplan.sh" ]

ENTRYPOINT [ "/opt/crashplan/run_crashplan.sh" ]

