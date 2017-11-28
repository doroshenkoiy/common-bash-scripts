#!/bin/sh
# Delete files older than max_age days
# --------------------------------------------------------------------------------------------------------
find_path="/usr/bin/find"
backup_path="/db/backup/rotate/"
max_age=10
# --------------------------------------------------------------------------------------------------------

${find_path} ${backup_path} -atime +${max_age} -delete










