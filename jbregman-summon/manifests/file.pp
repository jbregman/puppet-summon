define summon::file (
	$provider,
	$secrets_file = undef,
	$user = undef,
	$path = '/usr/bin:/bin',
	$map = [],
) {


	$the_secrets_file = $secrets_file
	$the_user = $user

 
	$values = map ($map) |$k| {

#		$filename = regsubst($name, '/', '_', 'G')
#		$template = "
#		print \"<%%= \"
#		print \"\\\"#{ENV['<%= @k %>']}\\\"\"
#		print \" %>\"
#		"
#
#		$ruby_file = "/tmp/summon-file-$filename-$k.rb"
#
#		file {"template-for-$k":
#			path => "$ruby_file",
#			content => inline_template($template),
#
#		} ->

		summon::exec {"get-secrets-for-$k":
        		command => "ruby $ruby_file > $ruby_file.erb",
        		secrets_file => $the_secrets_file,
        		provider => $provider,
        		user => $the_user,
        		require => [File["template-for-${k}"]],
		} 

		notify {"generated template $ruby_file":
			message => "$ruby_file",
		}
		
		
		

	} 

	notify {"values are":
		message => "$values",
	} ->

	file { '/Users/joshbregman/secret.conf':
		ensure => present,
		contents => template('/Users/joshbregman/secrets.erb'),
	}
                

}
