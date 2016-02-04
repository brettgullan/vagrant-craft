# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}


class system-update {

    exec { 'apt-get update':
        command => 'apt-get update',
    }

    $sysPackages = [ 'build-essential' ]
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

class nginx-setup {

    class { "nginx":
      source_dir       => "/vagrant/vagrant/files/nginx/",
      source_dir_purge => true, # Purge any existing files not present in $source_dir
      template => "/vagrant/vagrant/files/nginx/nginx.conf",
    }

    file { '/logs':
        ensure => directory,
    }

    package { 'python-software-properties':
        ensure => present,
    }

    exec { 'add-apt-repository ppa:nginx/stable':
        command => '/usr/bin/add-apt-repository ppa:nginx/stable',
        require => Package["python-software-properties"],
    }

    exec { 'apt-get update for nginx/stable':
        command => '/usr/bin/apt-get update',
        before => Package["nginx"],
        require => Exec['add-apt-repository ppa:nginx/stable'],
    }

    file { '/etc/nginx/sites-enabled/default':
        notify => Service["nginx"],
        ensure => link,
        target => "/etc/nginx/sites-available/default",
        require => Package["nginx"],
    }

    file { '/etc/nginx/sites-enabled/phpmyadmin':
        notify => Service["nginx"],
        ensure => link,
        target => "/etc/nginx/sites-available/phpmyadmin",
        require => Package["nginx"],
    }

    exec { 'restart nginx':
      command => 'nginx -s reload',
      require => Package["nginx"],
    }
    
}

class { "mysql":
    root_password => 'password',
}


class phpmyadmin-setup {

    exec { 'add-apt-repository ppa:tuxpoldo/phpmyadmin':
        command => '/usr/bin/add-apt-repository ppa:tuxpoldo/phpmyadmin',
        require => Package["python-software-properties"],
    }

    exec { 'apt-get update for tuxpoldo/phpmyadmin':
        command => '/usr/bin/apt-get update',
        before => Package["phpmyadmin"],
        require => Exec['add-apt-repository ppa:tuxpoldo/phpmyadmin'],
    }

    package { "phpmyadmin":
        ensure => 'installed',
        responsefile => "/vagrant/vagrant/files/seeds/phpmyadmin.seed",
        require => Package["nginx"],
    }
    
    file { "/phpmyadmin":
        ensure => link,
        target => "/usr/share/phpmyadmin",
        require => Package["phpmyadmin"],
    }

    file { '/var/lib/phpmyadmin/config.inc.php':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 777,
        source => '/vagrant/vagrant/files/phpmyadmin/config.inc.php',
        require => Package["phpmyadmin"],
    }

}

class { 'apt':
    always_apt_update    => true
}

Exec["apt-get update"] -> Package <| |>

include system-update
include dev-packages
include nginx-setup
include php-setup
include phpmyadmin-setup
