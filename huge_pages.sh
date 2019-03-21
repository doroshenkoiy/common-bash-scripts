#!/bin/sh
# How many memory do you need for HugePages ?  in Mb.
# For Mysql: innodb_buffer_pool + all other buffers. + `grep "Failed to allocate" error.log`
need_mem_mb="12*1024+508+256"

# linux usergroup, which can allocate HugePages
usergroup='mysql'

#  --------------------------------------------------------------------
usergroup_id=`id -g $usergroup`

need_mem_kb=`echo $((($need_mem_mb) * 1024))`
pagesize_kb=`cat /proc/meminfo | grep -i Hugepagesize | sed "s/\ kB$//" | sed "s/^Hugepagesize:\ *//"`
#  --------------------------------------------------------------------


echo "Memory:"
free -h
echo
cat /proc/meminfo | grep -i Huge

echo
echo " -------------------- "
echo
echo "Need mem(Mb): " $(($need_mem_mb))
echo "Need mem(Kb): " $need_mem_kb
echo "Huge Page size(Kb): "$pagesize_kb
echo "Usergroup ID: "$usergroup_id

echo 
echo " -------------------- "
echo 
echo "Current values(sysctl):"
sysctl vm.hugetlb_shm_group
sysctl vm.nr_hugepages
sysctl kernel.shmmax
sysctl kernel.shmall

echo 
echo " ---   RESULTS   ---"
echo 
echo "insert into /etc/sysctl.conf"
echo "vm.hugetlb_shm_group =" $usergroup_id
echo "vm.nr_hugepages =" $(($need_mem_kb / $pagesize_kb))
echo "kernel.shmmax =" $(($need_mem_kb*1024))
echo "kernel.shmall =" $(($need_mem_kb/4))
echo
echo " apply w/o reboot: sysctl --write --system"

