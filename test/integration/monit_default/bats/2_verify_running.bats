# tests/integration/monit_default/bats/2_verify_running.bats

@test "monit is running" {
  sudo /etc/init.d/monit status | grep -q "running"
}
