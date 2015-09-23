#!/bin/bash

# NOTE: Remove all rrds which might be around from an earlier run
rm -rf /var/lib/ganglia/rrds/*
rm -rf /mnt/ganglia/rrds/*

# Make sure rrd storage directory has right permissions
mkdir -p /mnt/ganglia/rrds
chown -R nobody:nobody /mnt/ganglia/rrds

# Install ganglia
# TODO: Remove this once the AMI has ganglia by default

yum -y remove httpd
yum remove php-cli* php-common* httpd-tools* php-process* php-xml*

GANGLIA_PACKAGES="ganglia ganglia-web ganglia-gmond ganglia-gmetad"

yum install -q -y $GANGLIA_PACKAGES;

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t -t $SSH_OPTS root@$node "yum install -q -y $GANGLIA_PACKAGES" & sleep 0.3
done
wait

# Post-package installation : Symlink /var/lib/ganglia/rrds to /mnt/ganglia/rrds
rmdir /var/lib/ganglia/rrds
ln -s /mnt/ganglia/rrds /var/lib/ganglia/rrds

sed -i 's/Listen 80/Listen 5080/g' /etc/httpd/conf/httpd.conf
