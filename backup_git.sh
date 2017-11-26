#!/bin/sh
# Backup server config into GIT. 
# --------------------------------------------------------------------------------------------------------
git_path='/backup/git-backupconf'
rsync_options='-rRtvh --no-specials --no-devices --ignore-missing-args --ignore-errors --copy-links --delete --delete-after --force --stats --progress'
rsync_exclude=" --exclude=/etc/alternatives --exclude=*.gz --exclude=*.pem --exclude=*.dat"
rsync_opt=${rsync_options}${rsync_exclude}
inst_progs='installed_programs.log'
services_log='systemd.log'
about_linux='linux.info'
storage_info='storage.info'

# perl_modules_log='perl_modules.log'
# perl_modules_list='/srv/scripts/list_perl_modules.pl'

# --------------------------------------------------------------------------------------------------------

rsync ${rsync_opt} /etc/ ${git_path}
rsync ${rsync_opt} /usr/local/etc/ ${git_path}
rsync ${rsync_opt} /srv/scripts/ ${git_path}

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

# Storage info
fdisk -l > ${git_path}/${storage_info}
pvdisplay --maps >> ${git_path}/${storage_info}
vgs >> ${git_path}/${storage_info}
lvs >> ${git_path}/${storage_info}

# версии модулей Perl
# ${perl_modules_list} | sort > ${git_path}/${perl_modules_log}


# --------------------------------------------------------------------------------------------------------
# ----    Git commit  ----

cd $git_path
git add --all *
git commit -m 'Automatic backup'
git push origin master

# --------------------------------------------------------------------------------------------------------.

