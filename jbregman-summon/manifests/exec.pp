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

	$home_var = "homedir_${user}"
	$home = inline_template("<%= scope.lookupvar(@home_var) %>")

	exec {'summon':
       		command => "summon -p $summon_provider -f $secrets_file $command",
       		environment => "HOME=$home",
       		user => "$user",
       		path => "/usr/local/bin:$path",
	}


}
