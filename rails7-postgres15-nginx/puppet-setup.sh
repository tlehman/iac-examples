#!/bin/sh
sudo apt install puppet
puppet module install puppetlabs-apt
puppet module install puppet-nginx
puppet module install puppet-postgresql
puppet module install jfryman-nginx # or the maintained fork/variant
puppet module install puppet-rbenv
