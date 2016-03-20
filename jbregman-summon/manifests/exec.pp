define summon::exec (
	$provider,
	$command,
	$secrets_file,
	$user,
	$path,
) {

	if $provider == 'conjur' {
		$summon_provider = 'summon-conjur'
	} elsif $provider == 'keyring' {
		$summon_provider = 'keyring.py'
	} else {
		fail("Unknown provider $provider")
	}

	user {'run-as-user':
		name => "$user",
		ensure => present,		
	}

	exec {'summon':
       		command => "summon -p $summon_provider -f $secrets_file $command",
       		environment => 'HOME=/Users/joshbregman',
       		user => "$::User['run-as-user']['home']",
       		path => "/usr/local/bin:$path",
		require => [User['run-as-user']],
	}


}
