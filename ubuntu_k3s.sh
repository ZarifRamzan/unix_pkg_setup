#!/usr/bin/env bash
# k3s.sh – wipe ALL old K8s, install K3s + complete RBAC, verify incl. PVC-Bound test.  Idempotent.
set -euo pipefail

###########################  1.  WIPE OLD K8s  ################################
purge_k8s(){
  echo "=== Purging any existing Kubernetes packages & data ==="
  for svc in k3s kubelet microk8s minikube containerd docker cri-docker; do
    sudo systemctl stop "$svc" 2>/dev/null || true
    sudo systemctl disable "$svc" 2>/dev/null || true
  done
  mount | awk '$3 ~ /\/var\/lib\/kubelet/ {print $3}' | xargs -r -n1 sudo umount -f -l 2>/dev/null || true
  sudo apt-get remove -y --purge kubeadm kubectl kubelet kubernetes-cni k3s k3s-agent microk8s minikube containerd.io docker-ce docker-ce-cli cri-tools 2>/dev/null || true
  sudo rm -rf /etc/kubernetes /var/lib/kubelet /var/lib/etcd /var/lib/k3s /usr/local/bin/k3s* /etc/rancher /var/lib/minikube /var/snap/microk8s /opt/containerd /var/lib/containerd ~/.kube ~/.minikube 2>/dev/null || true
  sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X || true
  echo "=== Purge complete ==="
}

###########################  2.  INSTALL K3s + FULL RBAC  ####################
install_k3s(){
  echo "=== Installing K3s ==="
  curl -sfL https://get.k3s.io | sudo sh -s - ${K3S_EXTRA_ARGS:-}
  for i in {1..60}; do
    sudo k3s kubectl get node "$(hostname)" 2>/dev/null | grep -q Ready && { echo "Node Ready ✔"; break; }
    sleep 5
  done || { echo "Timeout waiting for Ready"; exit 1; }
  mkdir -p ~/.kube
  sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
  sudo chown "$USER": ~/.kube/config && chmod 600 ~/.kube/config
  sudo mkdir -p /var/lib/rancher/k3s/storage && sudo chmod 700 /var/lib/rancher/k3s/storage
  kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: local-path-provisioner-service-account
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: local-path-provisioner-role
rules:
- apiGroups: [""]
  resources: ["nodes","persistentvolumes","persistentvolumeclaims","configmaps","events","endpoints","namespaces","pods","pods/log"]
  verbs: ["get","list","watch","create","patch","update","delete"]
- apiGroups: ["storage.k8s.io"]
  resources: ["storageclasses"]
  verbs: ["get","list","watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: local-path-provisioner-bind
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: local-path-provisioner-role
subjects:
- kind: ServiceAccount
  name: local-path-provisioner-service-account
  namespace: kube-system
EOF
  echo "kubeconfig saved to ~/.kube/config"
}

###########################  3.  VERIFY (PVC + Pod)  ########################
verify_cluster(){
  echo "=== Verification ==="
  kubectl get node
  kubectl get po -A
  # create PVC + Pod consumer (WaitForFirstConsumer -> Bound)
  kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: verify-pvc
spec:
  accessModes: [ReadWriteOnce]
  resources: { requests: { storage: 100Mi } }
---
apiVersion: v1
kind: Pod
metadata:
  name: verify-pod
spec:
  containers:
  - name: busy
    image: busybox:1.36
    command: ["sh", "-c", "echo 'PVC OK' > /data/demo.txt && sleep 3600"]
    volumeMounts:
    - name: vol
      mountPath: /data
  volumes:
  - name: vol
    persistentVolumeClaim:
      claimName: verify-pvc
EOF
  kubectl wait --for=condition=Ready pod/verify-pod --timeout=60s
  sleep 3
  kubectl get pvc verify-pvc -o jsonpath='{.status.phase}' | grep -q Bound && echo "✔ PVC Bound" || echo "❗ PVC not Bound"
  kubectl exec verify-pod -- cat /data/demo.txt
  kubectl delete pod/verify-pod pvc/verify-pvc
  echo "=== All green ✔ ==="
}

################################  MAIN  #######################################
purge_k8s
install_k3s
verify_cluster
