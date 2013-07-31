# test/integration/monit_default/bats/0_verify_installed.bats

@test "monit is installed and in the path" {
  PATH=$PATH:/usr/local/bin
  export PATH
  which monit
}

@test "monit configuration exists" {
  [ -f /etc/monitrc ]
}

@test "init script installed" {
  [ -f /etc/init/monit.conf ] || [ -f /etc/init.d/monit ]
}
