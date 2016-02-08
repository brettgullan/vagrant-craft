class php7-setup {

  # package install list
  $packages = [
     "php7.0",
     "php7.0-cli",
     "php7.0-fpm",
     "php7.0-common",
     "php7.0-dev",
     "php7.0-mysql",
     "php7.0-gd",
     "php7.0-intl",
     "php7.0-json",
     "php7.0-opcache",
     "php7.0-mcrypt",
     "php-curl",
     "php-imagick",
     "php-pear",
     "php-xdebug",
     "libapache2-mod-php7.0"
  ]
    
 #   "php",
 #   "php-cli",
 #   "php-fpm",
 #   "php-common",
 #   "php-dev",
 #   "php-mysql",
 #   "php-gd",
 #   "php-mcrypt",
 #   "php-curl",
 #   "php-imagick",
 #   "php-pear",
 #   "php-xdebug",
 #   "libapache2-mod-php"
    
#    "pkg-config",
#    "libmagickwand-dev",
#    "imagemagick"


  exec { 'add-apt-repository ppa:ondrej/php':
    command => '/usr/bin/add-apt-repository ppa:ondrej/php',
    require => Package["python-software-properties"],
  }

  exec { 'apt-get update for ondrej/php':
    command => '/usr/bin/apt-get update',
    before => Package[$packages],
	require => Exec['add-apt-repository ppa:ondrej/php'],
  }

  package { $packages:
    ensure => present,
    require => Exec["apt-get update"],
    notify => Service['apache2']
  }
#  ->
#  # in Ubuntu 14.04, it seems mcrypt has to be manually enabled:
#  exec { "php7enmod mcrypt && service apache2 reload":
#    require => Package["php-mcrypt"]
#  }

  # Increase xDebug's max nesting level to prevent problems with Craft:
  # cf. http://craftcms.stackexchange.com/a/1560/328
    exec { 'configure xdebug':
      command => "echo 'xdebug.max_nesting_level=200' >> /etc/php/mods-available/xdebug.ini",
      unless => "grep xdebug.max_nesting_level /etc/php/mods-available/xdebug.ini",
      require => Package["php-xdebug"],
      notify => Service['apache2']
    }
  # Note issues with xdebug and composer
  # See https://getcomposer.org/xdebug
  


#	package { "imagemagick":
#	    ensure => present,
#	    require => Package[$php],
#	}
#	
#	package { "libmagickwand-dev":
#	    ensure => present,
#	    require => Package["imagemagick"],
#	}

}

  