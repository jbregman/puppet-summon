define summon::provider (
) {

	if $name == "keyring" {
		summon::provider::keyring { 'install':}
	} elsif $name == "conjur" {
		summon::provider::conjur { 'install':}
	} else {
		fail ("unsupported summon provider $name")
	}
}
