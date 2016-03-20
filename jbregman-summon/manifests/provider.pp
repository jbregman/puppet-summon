define summon::provider (
) {

	if $name == "keyring" {

		class { 'python':
			version => '3.5.1',
		}

		file { '/usr/local/lib/summon':
			ensure => directory,
		}


		python::pip { 'keyring':
			pkgname => 'keyring',
		}		

		package { 'python-dbus':
			ensure => present,
		}


		python::pip {'pycrypto':
			pkgname => 'pycrypto',
		}

		python::pip {'secretstorage':
			pkgname => 'secretstorage',
			ensure => '2.1.4',
		}
	
		exec { 'install-keyring-provider':
			command => 'curl https://raw.githubusercontent.com/conjurinc/summon-keyring/master/ring.py >> /usr/local/lib/summon/keyring.py',
		        require => [
				Package['curl'],
				Python::Pip['keyring'],
				File['/usr/local/lib/summon']
			],
        	        path=> '/usr/bin:/bin',

		}

		file { '/usr/local/lib/summon/keyring.py':
			ensure => file,
			mode => 0777,
		}
	

	} else {
		fail ("unsupported summon provider $name")
	}
}