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

#include nginx-setup
#include php5-fpm-setup
#include phpmyadmin-setup

include apache-setup
include php5-setup


# -----------------------------------------------------------------
# Oddments
# -----------------------------------------------------------------

include curl
include composer

