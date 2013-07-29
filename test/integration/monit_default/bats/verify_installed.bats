@test "monit is installed and in the path" {
  which monit
}

@test "monit configuration exists" {
  [ -f /etc/monit.conf] || [ -f /etc/monit/monitrc ]
}
