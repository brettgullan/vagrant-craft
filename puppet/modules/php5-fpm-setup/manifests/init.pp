class php5-fpm-setup {

    $php = ["php5-fpm", "php5-cli", "php5-gd", "php5-curl", "php5-mcrypt", "php5-mysql", "php5-imagick"]

    exec { 'add-apt-repository ppa:ondrej/php5':
        command => '/usr/bin/add-apt-repository ppa:ondrej/php5',
        require => Package["python-software-properties"],
    }

    exec { 'apt-get update for ondrej/php5':
        command => '/usr/bin/apt-get update',
        before => Package[$php],
        require => Exec['add-apt-repository ppa:ondrej/php5'],
    }

    package { $php:
        notify => Service['php5-fpm'],
        ensure => latest,
    }

    package { "apache2.2-bin":
        notify => Service['nginx'],
        ensure => purged,
        require => Package[$php],
    }

    package { "imagemagick":
        ensure => present,
        require => Package[$php],
    }

    package { "libmagickwand-dev":
        ensure => present,
        require => Package["imagemagick"],
    }

    file { '/etc/php5/cli/php.ini':
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/vagrant/files/php/cli/php.ini',
        require => Package[$php],
    }

    file { '/etc/php5/fpm/php.ini':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/vagrant/files/php/fpm/php.ini',
        require => Package[$php],
    }

    file { '/etc/php5/fpm/php-fpm.conf':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/vagrant/files/php/fpm/php-fpm.conf',
        require => Package[$php],
    }

    file { '/etc/php5/fpm/pool.d/www.conf':
        notify => Service["php5-fpm"],
        owner  => root,
        group  => root,
        ensure => file,
        mode   => 644,
        source => '/vagrant/vagrant/files/php/fpm/pool.d/www.conf',
        require => Package[$php],
    }

    service { "php5-fpm":
        ensure => running,
        require => Package["php5-fpm"],
    }
}
