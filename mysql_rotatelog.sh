#!/bin/sh
# rotate error.log > error.log.20180323_1136-57
# 
# "ExecStartPre=/srv/scripts/mysql_rotatelog.sh" >> /lib/systemd/system/mysql.service
# systemctl daemon-reload

error_log_path="/var/log/mysql/"
error_log_file="error.log"
date_suffix=`date +%Y%m%d_%H%M-%S`

mv ${error_log_path}${error_log_file} ${error_log_path}${error_log_file}.${date_suffix}
