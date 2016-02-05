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

