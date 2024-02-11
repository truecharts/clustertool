#!/usr/bin/sudo bash

deploy_cni(){
rm -rf ./deps/cni/charts || true
rm -f ./deps/cni/values.yaml || true
cat ./cluster/kube-system/cilium/app/cilium-values.yaml > ./deps/cni/values.yaml
kustomize build --enable-helm ./deps/cni | kubectl apply -f -
rm -f ./deps/cni/values.yaml || true
rm -rf ./deps/csr-approver/charts || true
}
export deploy_cni

deploy_approver(){
rm -rf ./deps/csr-approver/charts || true
kustomize build --enable-helm ./deps/csr-approver | kubectl apply -f -
rm -rf ./deps/csr-approver/charts || true
popd >/dev/null 2>&1
}
export deploy_approver

deploy_metallb(){
rm -rf ./deps/metallb/charts || true
kustomize build --enable-helm ./deps/metallb | kubectl apply -f -
rm -rf ./deps/metallb/charts || true
popd >/dev/null 2>&1
}
export deploy_metallb

deploy_metallb_config(){
rm -rf ./deps/metallb-config/charts || true
kustomize build --enable-helm ./deps/metallb-config | kubectl apply -f -
rm -rf ./deps/metallb-config/charts || true
popd >/dev/null 2>&1
}
export deploy_metallb_config

deploy_openebs(){
rm -rf ./deps/openebs/charts || true
kustomize build --enable-helm ./deps/openebs | kubectl apply -f -
rm -rf ./deps/openebs/charts || true
popd >/dev/null 2>&1
}
export deploy_openebs

deploy_kubeapps(){
rm -rf ./deps/kubeapps/charts || true
kustomize build --enable-helm ./deps/kubeapps | kubectl apply -f -
rm -rf ./deps/kubeapps/charts || true
popd >/dev/null 2>&1
}
export deploy_kubeapps
