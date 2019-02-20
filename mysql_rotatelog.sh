#!/bin/sh
# rotate error.log > error.log.20180323_1136-57
#
# mkdir /lib/systemd/system/mysql.service.d
# echo "[Service]"  >> /lib/systemd/system/mysql.service.d/additions.conf
# echo "ExecStartPre=/srv/scripts/mysql_rotatelog.sh" >> /lib/systemd/system/mysql.service.d/additions.conf
# systemctl daemon-reload

error_log_path="/var/log/mysql/"
error_log_file="error.log"
date_suffix=`date +%Y%m%d_%H%M-%S`


if [ -f ${error_log_path}${error_log_file} ]; then
    mv ${error_log_path}${error_log_file} ${error_log_path}${error_log_file}.${date_suffix}
else
    echo "ERROR: File '${error_log_path}${error_log_file}' not found."
fi

