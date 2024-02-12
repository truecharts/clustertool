#!/usr/bin/sudo bash

prompt_yn_node () {
read -p "Healthcheck failed, is the currently updated node working correctly? please verify! (yes/no) " yn

case $yn in
    yes ) echo ok, we will proceed;;
    no ) echo exiting...;
        exit;;
    y ) echo ok, we will proceed;;
    n ) echo exiting...;
        exit;;
    * ) echo invalid response;
        prompt_yn_node;;
esac
}
export prompt_yn_node



check_health(){
 PREBOOTSTRAP=false
 
 
 if [ ! -z "$1" ]; then
   echo "Waiting for node to be online on ip ${1}..."
   sleep 5
   while ! ping -c1 ${1} &>/dev/null; do :; done
   echo "Waiting for node to respond to machine status on ip ${1}..."

   isup=0
   until [ "${isup}" = 1 ] ; do
    sleep 1
    status=$(timeout 1 talosctl --talosconfig=talosconfig -e "${1}" -n "${1}" get machinestatus -o jsonpath={.spec.stage}) 2>&1
    if [ "$status" == "running" ]; then
      echo "detected running node..."
	  isup=1
	elif [ ! -z "$2" ]; then
	  if [ "$status" == "$2" ]; then
        echo "detected running node..."
	    isup=1
	  fi
    fi

   done
 else
   echo "Waiting for node to respond to machine status on ip ${VIP}..."

   isup=0
   until [ "${isup}" = 1 ] ; do
    sleep 1
    status=$(timeout 1 talosctl --talosconfig=talosconfig -e "${VIP}" -n "${VIP}" get machinestatus -o jsonpath={.spec.stage}) 2>&1
    if [ "$status" == "running" ]; then
      echo "detected running node..."
	  isup=1
    fi
   done
 
   echo "Checking Cluster Health..."

   talosctl health --talosconfig clusterconfig/talosconfig -n ${VIP} || exit 1
 fi
}
export check_health
