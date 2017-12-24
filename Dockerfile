FROM centos:7

MAINTAINER Paul Krizak <paul.krizak@gmail.com>

VOLUME [ "/var/lib/crashplan", "/opt/crashplan/conf", "/opt/crashplan/cache", "/crashplan-store" ]

WORKDIR /

RUN [ "/usr/bin/yum", "-y", "--nogpgcheck", "install", "which", "wget", "expect", "net-tools", "libXScrnSaver" ]

RUN [ "/usr/bin/wget", "https://web-lbm-msp.crashplanpro.com/client/installers/CrashPlanPRO_4.9.0_1436674888490_33_Linux.tgz", "-O", "crashplan.tgz" ]

RUN [ "/usr/bin/tar", "-xzf", "crashplan.tgz" ]

RUN [ "/bin/rm", "-f", "*.tgz" ]

WORKDIR /crashplan-install

COPY [ "install.expect", "install.expect" ]

RUN [ "./install.expect" ]

EXPOSE 4245

WORKDIR /opt/crashplan

COPY [ "run_crashplan.sh", "run_crashplan.sh" ]

ENTRYPOINT [ "/opt/crashplan/run_crashplan.sh" ]

