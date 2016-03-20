define summon::provider::conjur {

	if $::osfamily == 'Darwin' {

		require homebrew

		exec {'download-summon-conjur':
			command => 'curl -SsL https://github.com/jbregman/summon-conjur/raw/master/pkg/dist/summon-conjur_v0.1.4_darwin-amd64.zip > /tmp/summon-conjur_v0.1.4_darwin-amd64.zip',
			path => '/usr/bin:/bin',
			unless => 'test -f /tmp/summon-conjur_v0.1.4_darwin-amd64.zip',
		}

		exec {'install-summon-conjur':
			command => 'unzip summon-conjur_v0.1.4_darwin-amd64.zip -d /usr/local/lib/summon',
			cwd => '/tmp',
			path => '/usr/bin:/bin',
			require => [Exec['download-summon-conjur']],
			unless => 'test -f /usr/local/lib/summon/summon-conjur',
		}

		package {'conjur-cli':
			source => 'https://github.com/conjurinc/cli-ruby/releases/download/v4.30.1/conjur-4.30.1-1.pkg',
			ensure => present,
		}

	}
}
