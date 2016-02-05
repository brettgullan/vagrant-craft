class nginx-setup {

    class { "nginx":
      source_dir       	=> "/vagrant/vagrant/files/nginx/",
      source_dir_purge 	=> true, # Purge any existing files not present in $source_dir
      template 			=> "/vagrant/vagrant/files/nginx/nginx.conf",
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