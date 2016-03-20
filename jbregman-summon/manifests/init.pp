# == Class: summon
#
# Full description of class summon here.
#
# === Parameters
#
#
# [*version*]
#   The version of summon to install.  The default is to install the latest.
#   This module supports installing version 0.4.0   
#   
#
# 
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { summon:
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class summon {

    if $::osfamily == 'Darwin' {
	require homebrew
    	package {'curl':
		ensure => present,
		provider => brew,
    	}

	exec {'download-summon':
		command => 'curl -sSL https://github.com/conjurinc/summon/releases/download/v0.4.0/summon_v0.4.0_darwin_amd64.tar.gz > /tmp/summon_v0.4.0_darwin_amd64.tar.gz',
		require => [Package['curl']],
		path=> '/usr/bin:/bin',
		unless => 'test -f /tmp/summon_v0.4.0_darwin_amd64.tar.gz',	
	}

	exec {'unzip-summon':
		command => 'gzip -d /tmp/summon_v0.4.0_darwin_amd64.tar.gz',
		path=> '/usr/bin:/bin',
		unless => 'test -f /tmp/summon_v0.4.0_darwin_amd64.tar',
		require => [Exec['download-summon']],
	}

	exec {'install-summon':
		command => 'tar -xvf /tmp/summon_v0.4.0_darwin_amd64.tar',
		path => '/usr/bin:/bin',
		cwd => '/usr/local/bin',
		unless => 'test -f /usr/local/bin/summon',
		require => [Exec['unzip-summon']],
	}

    } else {
    	package {'curl':
		ensure => present
    	}
    	exec {'install-summon':
		command => 'curl -sSL https://raw.githubusercontent.com/conjurinc/summon/master/install.sh | bash',
        	require => [Package['curl']],
		path=> '/usr/bin:/bin',
        	unless => 'test -f /usr/local/bin/summon',

    	}		
    }



}
