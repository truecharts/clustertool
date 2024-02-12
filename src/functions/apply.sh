#!/usr/bin/sudo bash

apply_talos_config(){

  echo ""
  echo "-----"
  echo "Applying TalosOS Cluster config to cluster ..."
  echo "-----"

  prompt_bootstrap

  while IFS=';' read -ra CMD <&3; do
    for cmd in "${CMD[@]}"; do
      name=$(echo $cmd | sed "s|talosctl apply-config --talosconfig=./clusterconfig/talosconfig --nodes=||g" | sed -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'// | sed "s| --file=./clusterconfig/||g" | sed "s|main-||g" | sed "s|.yaml||g" | sed "s|--insecure||g")
      ip=$(echo $cmd | sed "s|talosctl apply-config --talosconfig=./clusterconfig/talosconfig --nodes=||g" | sed "s| --file=./clusterconfig/.*||g")
      echo ""
      echo "Applying new Talos Config to ${name}"
      $cmd -i 2>/dev/null || $cmd || echo "Failed to apply config..."
	  if $bootstrap; then
        check_node_health ${ip} "booting"
	  else
        check_node_health ${ip} "booting"
	  fi
    done
  done 3< <(talhelper gencommand apply)
  echo ""
  echo "Config Apply finished..."

  if $bootstrap; then
    bootstrap
  fi
  
  check_node_health ${VIP}
  apply_kubeconfig
  
  echo "Deploying manifests..."
  deploy_cni
  # deploy_approver
  echo "Approving Certs..."
  approve_certs
  check_health
  echo "Deploying helm charts..."
  deploy_metallb
  deploy_metallb_config
  deploy_openebs
  deploy_kubeapps

  echo "Bootstrapping/Expansion finished..."

}
export -f apply_talos_config