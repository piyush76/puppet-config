class mediawiki {

  $wikimetanamespace = hiera('mediawiki::wikimetanamespace')
  $wikisitename      = hiera('mediawiki::wikisitename')
  $wikiserver        = hiera('mediawiki::wikiserver')
  $wikidbserver      = hiera('mediawiki::wikidbserver')
  $wikidbname        = hiera('mediawiki::wikidbname')
  $wikidbuser        = hiera('mediawiki::wikidbuser')
  $wikidbpassword    = hiera('mediawiki::wikidbpassword')
  $wikiupgradekey    = hiera('mediawiki::wikiupgradekey')
 

  $phpmysql = $osfamily ? {
    'redhat' => 'php-mysql',
    'debian' => 'php5-mysql',
    default  => 'php-mysql',
  }

  package { $phpmysql:
    ensure => 'present',
  }

  if $osfamily == 'redhat' {
    package { 'php-xml':
      ensure => 'present',
    }
  }

 class { '::apache':
  docroot    => '/var/www/html',
  mpm_module => 'prefork',
  subscribe  => Package[$phpmysql],
  }

  class { '::apache::mod::php':}

  vcsrepo { '/var/www/html':
    ensure   => 'present',
    provider => 'git',
    source   => "https://github.com/wikimedia/mediawiki.git",
    revision => 'REL1_23',
  }

  file { '/var/www/html/index.html':
    ensure => 'absent',
  }

  class { '::mysql::server':
    root_password => 'training',
  }
  
  class { '::firewall':}

  firewall { '000 allow http access':
    port   => '80',
    proto  => 'tcp',
    action => 'accept',
  } 

  file { 'LocalSettings.php':
    path    => '/var/www/html/LocalSettings.php',
    ensure  => 'file',
    content => template('mediawiki/LocalSettings.erb'),
  }


}


