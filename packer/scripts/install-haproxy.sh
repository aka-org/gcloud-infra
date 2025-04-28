set -e

export DEBIAN_FRONTEND=noninteractive

echo "[+] Installing HAProxy"
apt-get install -y haproxy
systemctl stop haproxy
systemctl disable haproxy
