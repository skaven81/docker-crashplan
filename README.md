CrashPlan container
===================

As CrashPlan updates their software, you will need to update
the download URL and tarball name in the Dockerfile.

After building the container, run it like so:

```
$ docker run -d --net=host --name mycrashplan --restart=always \
        -v /raid/crashplan-conf/conf:/opt/crashplan/conf \
        -v /raid/crashplan-conf/cache:/opt/crashplan/cache \
        -v /raid/crashplan-conf/var:/var/lib/crashplan \
        -v /raid/crashplan-store:/crashplan-store \
        -v /raid:/raid5:ro -v /:/geofront-root:ro \
        -p 4245:4245 \
        crashplan
```

The volumes for `/opt/crashplan/{conf,cache}`, `/var/lib/crashplan`,
and `/crashplan-store` are required, and MUST be mounted on persistent
storage outside the crashplan container.

Add additional volumes (`raid5` and `geofront-root` above) to expose
data to CrashPlan to perform backups.  You should use the `:ro` option
to ensure your data to be backed up can only be read, not written.

The first time you start the container, the UI will probably come up
bound to `127.0.0.1`.  Just restart the container and it will come
up bound to `0.0.0.0`.  To connect to it, have `CrashPlanDesktop`
installed on a system, and edit `/var/lib/crashplan/.ui_info` on that
machine.  Edit the IP address and auth token based on the UI info
of the server.  Then run `CrashPlanDesktop` and it should connect
to the remote server.

