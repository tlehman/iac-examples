#!/bin/sh
wget https://apt.puppet.com/puppet8-release-focal.deb
sudo dpkg -i puppet8-release-focal.deb
puppet module install puppetlabs-apt
puppet module install puppet-nginx
puppet module install puppet-postgresql
puppet module install puppet-rbenv
