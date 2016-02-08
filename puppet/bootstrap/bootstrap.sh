#!/usr/bin/env bash
# Bootstraps the VM, ready for provisioning with Puppet.
echo ''
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo 'Bootstrapping the VM:'

# Are we punching above our weight?
if [ "$EUID" -ne "0" ]; then
  echo '- The bootstrap script must be run as root!'
  exit 1
fi

# Download and register the Puppet Labs package.
echo '- Registering the Puppet package...'
wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
dpkg -i puppetlabs-release-pc1-trusty.deb >/dev/null

# Update the packages.
echo '- Updating the packages...'
apt-get update >/dev/null

# Install Puppet.
echo '- Installing Puppet...'
apt-get install -y puppet-common >/dev/null

# Tidy up.
echo '- Tidying up...'
rm puppetlabs-release-pc1-trusty.deb

# All done.
echo '- VM is bootstrapped and ready to go...'
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo ''