#!/bin/sh
# Backup PostgreSQL DB.
#

# --------------------------------------------------------------------------------------------------------
backup_path='/backup/db/rotate'
now=`date +%Y%m%d_%H%M`
gzip_level=8

# --------------------------------------------------------------------------------------------------------


echo "Dumping globals:"
 sudo -u postgres pg_dumpall --globals-only | gzip -${gzip_level} | pv -terab  > ${backup_path}/${now}_pg_globals_only.sql.gz

db_list=`sudo -u postgres psql -l | awk '{ print $1}' | grep -vE '^-|^List|^Name|^Список|^Имя|template[0|1]|^postgres$|^\||^\(|^$'`


for i in ${db_list}; do
    echo "Dumping db schema:" $i
    sudo -u postgres pg_dump --schema-only --format=plain $i | gzip -${gzip_level} | pv -terab > ${backup_path}/${now}_${i}_schema.sql.gz
    echo "Dumping db:       " $i
    sudo -u postgres pg_dump --data-only --insert --format=plain $i | gzip -${gzip_level} | pv -terab > ${backup_path}/${now}_${i}_data.sql.gz
done
echo "Dump done!"



# --------------------------------------------------------------------------------------------------------.

