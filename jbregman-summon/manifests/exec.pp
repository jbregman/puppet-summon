define summon::exec (
	$provider = 'conjur',
	$command,
	$secrets_file,
	$user,
	$path = '/usr/bin:/bin',
	$output = undef,
) {

	if $provider == 'conjur' {
		summon::provider { 'conjur': }
		$summon_provider = 'summon-conjur'
	} elsif $provider == 'keyring' {
		summon::provider { 'keyring': }	
		$summon_provider = 'keyring.py'
	} else {
		fail("Unknown provider $provider")
	}

	$home_var = "homedir_${user}"
	$home = inline_template("<%= scope.lookupvar(@home_var) %>")

	notify {"Running summon-$name":
		message => "$name",

	}

	if ($output == undef) {
		$the_command = "summon -p $summon_provider -f $secrets_file $command"
	} else {
		$the_command = "summon -p $summon_provider -f $secrets_file $command > $output"
	}

	exec {"summon-$name":
       		command => "$the_command",
       		environment => "HOME=$home",
       		user => "$user",
       		path => "/usr/local/bin:$path",
	}


}
