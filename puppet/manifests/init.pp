# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}


class system-update {

    exec { 'apt-get update':
        command => 'apt-get update',
    }

    $sysPackages = [ 'software-properties-common', 'python-software-properties', 'build-essential' ]
    package { $sysPackages:
        ensure => 'installed',
        require => Exec['apt-get update'],
    }

}

class dev-packages {

    $devPackages = [ 'curl', 'git-core']
    package { $devPackages:
        ensure => 'installed',
        require => Exec['apt-get update'],
    }
}


class { "mysql":
    root_password => 'password',
}


class { 'apt':
    always_apt_update    => true
}

Exec["apt-get update"] -> Package <| |>

include system-update
include dev-packages

## PHP5/Nginx Setup
# This is the original vagrant-craft install
#include nginx-setup
#include php5-fpm-setup
#include phpmyadmin-setup


## PHP/Apache setup
# This is adapted from a range of other sources to provide LAMP functionality
include apache-setup
#include php5-setup
include php7-setup


# -----------------------------------------------------------------
# Oddments
# -----------------------------------------------------------------

include curl
include composer

