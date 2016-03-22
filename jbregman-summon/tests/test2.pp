# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
include summon

$my_secrets_file = "
MYSECRET: !var ${environment}/secret/path
MYSECRET2: !var ${environment}/secret/path2
"


file {'/opt/secrets.yml':
	content => "$my_secrets_file",
} ->

summon::exec {'test2':
	command => "ruby /opt/build_conf.rb",
	secrets_file => '/opt/secrets.yml',
	user => 'joshbregman',
	require => [File['/opt/secrets.yml']],
	output => "/Users/joshbregman/test2.out"
} 
