#!/bin/sh
# Change OOM_killer score to defend mysql, glusterfs
# crontab -->  @reboot
# 	# echo "@reboot         root    /srv/scripts/oom_change.sh" >> /etc/crontab
#
# View oom_score:
# Mysql
# cat /proc/$(pidof mysqld)/oom_score 
# cat /proc/$(pidof mysqld)/oom_score_adj
# PostgreSQL
# ps axu| grep /usr/lib/postgresql/10/bin/postgres|head -n 1 | cut -f3 -d" "| parallel --will-cite "cat /proc/{}/oom_score; cat /proc/{}/oom_score_adj"

# --------------------------------------------------------------------------------------------------------
sleep 120
pgrep mysqld   | parallel --will-cite "echo '-700' > /proc/{}/oom_score_adj"
pgrep gluster  | parallel --will-cite "echo '-700' > /proc/{}/oom_score_adj"
ps axu| grep /usr/lib/postgresql/10/bin/postgres|head -n 1 | cut -f3 -d" "|parallel --will-cite "echo '-700' > /proc/{}/oom_score_adj"
# --------------------------------------------------------------------------------------------------------.

