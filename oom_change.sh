#!/bin/sh
# Change OOM_killer score to defend mysql, glusterfs
# crontab -->  @reboot
# 	# echo "@reboot         root    /srv/scripts/oom_change.sh" >> /etc/crontab
# --------------------------------------------------------------------------------------------------------
sleep 120
pgrep mysqld | parallel --will-cite "echo '-700' > /proc/{}/oom_score_adj"
pgrep gluster | parallel --will-cite "echo '-700' > /proc/{}/oom_score_adj"
# --------------------------------------------------------------------------------------------------------.

