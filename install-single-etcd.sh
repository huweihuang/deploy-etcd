#!/bin/bash
set -e
set -x

NODE1_IP=$1

ETCD_VER=${ETCD_VER:-v3.5.3}
ETCD_NAME=${ETCD_NAME:-"etcd01"}
ETCD_DATA_DIR=${ETCD_DATA_DIR:-"/data/etcd"}
BIN_DIR="/usr/bin"

# clean
rm -fr /lib/systemd/system/etcd.service /etc/systemd/system/etcd.service
rm -fr ${BIN_DIR}/etcd*
rm -fr ${ETCD_DATA_DIR}

# download etcd bin
rm -fr etcd-${ETCD_VER}-linux-amd64.tar.gz etcd-${ETCD_VER}-linux-amd64
wget https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar -zvxf etcd-${ETCD_VER}-linux-amd64.tar.gz
cp -fr etcd-${ETCD_VER}-linux-amd64/etcd* ${BIN_DIR}/

# add etcd serivce
cat > /lib/systemd/system/etcd.service << EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=${BIN_DIR}/etcd
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# add etcd conf
mkdir -p /etc/etcd
cat > /etc/etcd/etcd.conf << EOF
ETCD_NAME="${ETCD_NAME}"
ETCD_DATA_DIR="${ETCD_DATA_DIR}"

# Client configuration
ETCD_ADVERTISE_CLIENT_URLS="http://${NODE1_IP}:2379"
ETCD_LISTEN_CLIENT_URLS="http://${NODE1_IP}:2379,http://127.0.0.1:2379"
EOF

systemctl daemon-reload
systemctl enable etcd
systemctl restart etcd
