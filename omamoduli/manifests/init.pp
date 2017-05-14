class omamoduli {
	package {'iptables-persistent':
	 ensure => installed,
	 allowcdrom => true,
	}

        file { '/etc/iptables/rules.v4':
         ensure  => 'file' ,
         content  => template("omamoduli/iprules"),
	 require => Package['iptables-persistent'] ,
	 notify => Exec['iptables'] ,
        }

        package {'ssh':
         ensure => installed ,
         allowcdrom => true ,
        }

	file { '/etc/ssh':
	 ensure => directory
	}

        file { '/etc/ssh/sshd_config':
         content  => template("omamoduli/sshd_config"),
         require => Package['ssh'] ,
	 notify => Service['ssh'],
        }
															 
        service { 'ssh':
         ensure => running ,
         enable => true ,
         require => Package['ssh'],
        }

	package {'apache2':
	 ensure => installed ,
	 allowcdrom => true ,
	}
	
	file { '/var/www/testi.com':
	 ensure => 'directory' ,
	 require => Package['apache2'] ,
         group => 'www-data',
         owner => 'root',
         mode => 0755,
	}

        file { '/var/www/testi.com/logs':
         ensure => 'directory' ,
         require => Package['apache2'] ,
         group => 'www-data',
         owner => 'root',
         mode => 0775,
        }

        file { '/var/www/testi.com/index.html':
         ensure => 'file' ,
         require => Package['apache2'] ,
	 content => 'trolololo' ,
         group => 'www-data',
         owner => 'root',
	 mode => 0755,
        }
	
	file { '/etc/apache2/sites-available/testi.com.conf':
    	 ensure  => 'file' ,
    	 content  => template("omamoduli/testi.com.erb"),
         group => 'www-data',
         owner => 'root',
         mode => 0755,
	 require => Package['apache2'] ,
	}
	
        file { '/etc/apache2/sites-enabled/testi.com.conf':
         ensure  => 'link' ,
	 target => '/etc/apache2/sites-available/testi.com.conf' ,
	 notify => Service['apache2'] ,
	 require => Package['apache2'] ,
        }

        file { '/etc/apache2/sites-enabled/000-default.conf':
         ensure  => 'absent' ,
	 require => Package['apache2'] ,
        }

	service { 'apache2':
  	 ensure => running ,
  	 enable => true ,
	 require => Package['apache2'],
	}

	exec { 'iptables':
  	 command => "/bin/bash -c '/etc/puppet/modules/omamoduli/iptables.sh'",
	}


}
