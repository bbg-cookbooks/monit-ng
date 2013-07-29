# test/integration/monit_default/bats/1_verify_configured.bats

@test "global rc passes configuration test" {
  [ -f /etc/monit.conf ] && monit -tc /etc/monit.conf || monit -tc /etc/monit/monitrc
}

@test "init script installed" {
  [ -f /etc/init.d/monit ]
}

@test "includes pass configuration tests" {
  if [ -d /etc/monit.d ]; then
    for rc in $(ls /etc/monit.d); do monit -tc /etc/monit.d/$rc; done
  elif [ -d /etc/monit/conf.d ]; then
    for rc in $(ls /etc/monit/conf.d); do monit -tc /etc/monit/conf.d/$rc; done
  else
    exit 1
  fi
}
