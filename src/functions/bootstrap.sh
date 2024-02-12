#!/usr/bin/sudo bash

prompt_bootstrap () {
read -p "Should we bootstrap a new cluster? (yes/no) " yn

case $yn in
    yes ) echo ok, enabling bootstrap;
        export bootstrap=1
		;;
    no ) echo ok, we will proceed without bootstrapping
		;;
    y ) echo ok, enabling bootstrap;
        export bootstrap=1
		;;
    n ) echo ok, we will proceed without bootstrapping
	;;
    * ) echo invalid response;
        prompt_bootstrap
		;;
esac
}
export prompt_bootstrap

bootstrap(){
  echo ""
  echo "-----"
  echo "Bootstrapping TalosOS Cluster..."
  echo "-----"
  check_health ${MASTER1IP} "booting"
  talhelper gencommand bootstrap | bash || (echo "Bootstrap Failed or not needed retrying..." && sleep 5 && talhelper gencommand bootstrap | bash )
}
export -f bootstrap