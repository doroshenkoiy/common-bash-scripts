#!/bin/sh
# Backup server config into GIT.
#
# create dir /backup/git-backupconf:
#	$ git init /backup/git-backupconf
# Add executable bit
#	$ chmod +x backup_git.sh
# Add /etc/crontab
# 	0 0    * * *   root    /srv/scripts/backup_git.sh
# Add git config.
#	$ git config --global user.name `uname -n`
#	$ git config --global user.email "none@none.com"

# --------------------------------------------------------------------------------------------------------
git_path='/backup/git-backupconf'
rsync_options='-rRtvh --delete --executability --no-specials --no-devices --ignore-missing-args --ignore-errors --copy-links --delete --delete-after --force --stats --progress'
rsync_exclude=" --exclude=/etc/alternatives --exclude=*.gz --exclude=*.pem --exclude=*.dat --exclude=*.log"
rsync_opt=${rsync_options}${rsync_exclude}
inst_progs='installed_programs.log'
services_log='systemd.log'
about_linux='linux.info'
storage_info='storage.info'
network_info='network.info'

etcd_info='etcd.info'
patroni_info='patroni.info'
postgresql_info='postgresql.info'
postgresql_sql='/srv/scripts/postgresql_info.sql'
PGPASSWORD=superpassword
pguser='pg_user'

# perl_modules_log='perl_modules.log'
# perl_modules_list='/srv/scripts/list_perl_modules.pl'

# --------------------------------------------------------------------------------------------------------

rsync ${rsync_opt} /etc/ ${git_path}
rsync ${rsync_opt} /usr/local/etc/ ${git_path}
rsync ${rsync_opt} /srv/scripts/ ${git_path}
rsync ${rsync_opt} /usr/lib/systemd/system ${git_path}
rsync ${rsync_opt} /usr/lib/systemd/system-preset ${git_path}
rsync ${rsync_opt} /usr/lib/systemd/user ${git_path}
rsync ${rsync_opt} /usr/lib/systemd/user-preset ${git_path}


# installed applications
dpkg-query --list > ${git_path}/${inst_progs}
sed --in-place 1,5d ${git_path}/${inst_progs}

# Active services, targets, etc
systemctl --all --full --no-legend --no-pager  > ${git_path}/${services_log}

sed --in-place  /'^$'/d  ${git_path}/${services_log}
sed --in-place  /'^  UNIT .*LOAD .*ACTIVE .*SUB'/d  ${git_path}/${services_log}
sed --in-place  /'^.* Reflects whether the unit definition was properly loaded.'/d  ${git_path}/${services_log}
sed --in-place  /'^.* The high-level unit activation state, i.e. generalization of SUB.'/d  ${git_path}/${services_log}
sed --in-place  /'^.* The low-level unit activation state, values depend on unit type.'/d  ${git_path}/${services_log}
sed --in-place  /'^.* loaded units listed'/d  ${git_path}/${services_log}
sed --in-place  /'^.*To show all installed unit files use'/d  ${git_path}/${services_log}
sort --output=${git_path}/${services_log}  < ${git_path}/${services_log}

# Linux info(release, kernel)
lsb_release -d > ${git_path}/${about_linux}
uname -a >> ${git_path}/${about_linux}
echo "Virtualization: "`systemd-detect-virt` >> ${git_path}/${about_linux}

# Storage info
fdisk -l > ${git_path}/${storage_info}
pvdisplay --maps >> ${git_path}/${storage_info}
echo >> ${git_path}/${storage_info}
vgs -v >> ${git_path}/${storage_info}
echo >> ${git_path}/${storage_info}
lvs -v >> ${git_path}/${storage_info}

# Network info
ip -d a > ${git_path}/${network_info}

# версии модулей Perl
# ${perl_modules_list} | sort > ${git_path}/${perl_modules_log}

# Etcd info
etcdctl --version > ${git_path}/${etcd_info}
echo " " >> ${git_path}/${etcd_info}
etcdctl cluster-health >> ${git_path}/${etcd_info}


# Patroni info
patronictl version > ${git_path}/${patroni_info}
echo " " >> ${git_path}/${patroni_info}
patronictl show-config >> ${git_path}/${patroni_info}
echo " " >> ${git_path}/${patroni_info}
patronictl list >> ${git_path}/${patroni_info}

# PostgreSQL info
set -x
export PGPASSWORD

psql --version > ${git_path}/${postgresql_info}
psql --username=postgres -w --host=127.0.0.1 --port=5432 --file=$postgresql_sql  >> ${git_path}/${postgresql_info}

unset PGPASSWORD


# --------------------------------------------------------------------------------------------------------
# ----    Git commit  ----

cd ${git_path}
git add --all *
git commit -m 'Auto backup'
# git push origin master

# --------------------------------------------------------------------------------------------------------.

