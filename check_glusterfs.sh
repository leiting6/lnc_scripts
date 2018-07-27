#!/usr/bin/env bash

keepalived_log="/usr/local/keepalived/check_glusterfs.log"

# monitor haproxy process, if con't get haproxy or restart process
# then kill keepalived let backup machine take the virtual ip
if [ `netstat -anp | grep "0.0.0.0:24007" | wc -l` -eq 0 ];then
    `date` >> $keepalived_log
    echo -e "restart glusterfs failed.\nkill keepalived." >> $keepalived_log
    systemctl stop keepalived
    exit 1
fi
