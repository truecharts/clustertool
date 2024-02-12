#!/usr/bin/sudo bash

upgrade_talos_nodes () {

  talhelper gencommand upgrade --extra-flags=--preserve=true | bash

  check_health
  echo "updating kubernetes to latest version..."
   talhelper gencommand upgrade-k8s -n ${MASTER1IP}
  check_health
}
export upgrade_talos_nodes