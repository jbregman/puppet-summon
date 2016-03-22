build:
	puppet module build
install: build
	puppet module install pkg/jbregman-summon-0.1.0.tar.gz --ignore-dependencies --force

tests: install
	puppet apply --parser=future tests/init.pp

wordpress:  install
	puppet apply --parser=future tests/wordpress.pp
	
