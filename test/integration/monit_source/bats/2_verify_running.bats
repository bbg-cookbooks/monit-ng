# tests/integration/monit_default/bats/2_verify_running.bats

@test "monit is running" {
  status monit | grep -q "running"
}
