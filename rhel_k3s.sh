#!/bin/bash
set -e

# Detect user home walaupun run dengan sudo
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    USER_NAME="$SUDO_USER"
else
    USER_HOME="$HOME"
    USER_NAME="$USER"
fi

BASHRC="$USER_HOME/.bashrc"
KUBECONFIG="$USER_HOME/.kube/config"

echo "[INFO] Fixing non-sudo kubectl for user: $USER_NAME"

# 1. Pastikan kubeconfig ada & permission betul
echo "[INFO] Setting up kubeconfig at $KUBECONFIG"
mkdir -p "$USER_HOME/.kube"
sudo cp -f /etc/rancher/k3s/k3s.yaml "$KUBECONFIG"
sudo chown "$USER_NAME":"$USER_NAME" "$KUBECONFIG"
sudo chmod 644 "$KUBECONFIG"

# 2. Tambah KUBECONFIG ke .bashrc kalau belum ada
echo "[INFO] Adding KUBECONFIG to $BASHRC"
if ! grep -q "export KUBECONFIG=" "$BASHRC" 2>/dev/null; then
    echo '' >> "$BASHRC"
    echo '# K3s non-sudo kubectl fix' >> "$BASHRC"
    echo 'export KUBECONFIG=~/.kube/config' >> "$BASHRC"
fi

# 3. Force load ke current session
echo "[INFO] Loading KUBECONFIG into current terminal..."
export KUBECONFIG="$KUBECONFIG"

echo ""
echo "==================== VERIFICATION ===================="
echo "Nodes (non-sudo kubectl):"
kubectl get nodes -o wide

echo ""
echo "Pods:"
kubectl get pods --all-namespaces

echo ""
echo "====================================================="
echo "[SUCCESS] Non-sudo kubectl dah settle 100%!"
echo "- kubectl get nodes → terus jadi tanpa sudo"
echo "- Buka terminal baru pun automatic"
echo "Deploy je apa kau suka sekarang bro! 🚀"
