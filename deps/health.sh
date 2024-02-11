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
   while ! talosctl -e "${1}" -n "${1}" get machinestatus --talosconfig=./clusterconfig/talosconfig &>/dev/null; do :; done
 else
     echo "Checking Cluster Health..."
     talosctl health --talosconfig clusterconfig/talosconfig -n ${VIP} || exit 1
 fi
}
export check_health
