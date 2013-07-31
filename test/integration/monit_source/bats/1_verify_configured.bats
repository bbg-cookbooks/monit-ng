# test/integration/monit_default/bats/1_verify_configured.bats

@test "global rc passes configuration test" {
  [ -f /etc/monitrc ] && /usr/local/bin/monit -tc /etc/monitrc
}

@test "includes pass configuration tests" {
  if [ -d /etc/monit.d ]; then
    for rc in $(ls /etc/monit.d); do /usr/local/bin/monit -tc /etc/monit.d/$rc; done
  elif [ -d /etc/monit/conf.d ]; then
    for rc in $(ls /etc/monit/conf.d); do /usr/local/bin/monit -tc /etc/monit/conf.d/$rc; done
  else
    exit 1
  fi
}
