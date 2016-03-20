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

summon::provider { 'keyring': }
summon::provider { 'conjur': }

$secrets_file = "
MYSECRET !var ${::domain}/${environment}/secret/path
MY_OTHER_SECRET !var ${::domain}/${environment}/secret/path2
"

file {'/opt/secrets.yml':
	content => "$secrets_file",
}

exec {'test':
	command => "summon -p summon-conjur --yaml 'MYSECRET: !var secret/path' printenv MYSECRET",
	environment => 'HOME=/Users/joshbregman',
	user => 'joshbregman',
	path => '/usr/local/bin:/usr/bin',
}
