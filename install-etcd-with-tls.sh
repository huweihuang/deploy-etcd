#!/bin/bash
set -e
set -x

ETCD_VER=${ETCD_VER:-v3.5.3}
ETCD_NAME=${ETCD_NAME:-"etcd01"}
ETCD_DATA_DIR=${ETCD_DATA_DIR:-"/data/etcd"}
ETCD_HOME="/etc/etcd"
ETCD_PKI_DIR="${ETCD_HOME}/pki"
BIN_DIR="/usr/bin"

NODE1_IP=
NODE2_IP=
NODE3_IP=
Master_IP=

while getopts ":a:b:c:m:v:n:d:" opt
do
    case $opt in
        a) NODE1_IP=$OPTARG
        echo "NODE1_IP value: $OPTARG"
        ;;
        b) NODE2_IP=$OPTARG
        echo "NODE1_IP value: $OPTARG"
        ;;
        c) NODE3_IP=$OPTARG
        echo "NODE1_IP value: $OPTARG"
        ;;
        m) Master_IP=$OPTARG
        echo "M_IP value: $OPTARG"
        ;;        
        v) ETCD_VER=$OPTARG
        echo "ETCD_VER value: $OPTARG"
        ;;
        n) ETCD_NAME=$OPTARG
        echo "ETCD_NAME value: $OPTARG"
        ;;
        d) ETCD_DATA_DIR=$OPTARG
        echo "ETCD_DATA_DIR value: $OPTARG"
        ;;                
        ?)
        echo "invalid arg"
        exit 1;;
    esac
done


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
EnvironmentFile=-${ETCD_HOME}/etcd.conf
ExecStart=${BIN_DIR}/etcd
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# add etcd conf
mkdir -p ${ETCD_HOME}
cat > ${ETCD_HOME}/etcd.conf << EOF
ETCD_NAME="${ETCD_NAME}"
ETCD_DATA_DIR="${ETCD_DATA_DIR}"

# Initial cluster configuration
ETCD_INITIAL_CLUSTER="etcd01=https://${NODE1_IP}:2380,etcd02=https://${NODE2_IP}:2380,etcd03=https://${NODE3_IP}:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"

# Peer configuration
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://${Master_IP}:2380"
ETCD_LISTEN_PEER_URLS="https://${Master_IP}:2380"

# Client configuration
ETCD_ADVERTISE_CLIENT_URLS="https://${Master_IP}:2379"
ETCD_LISTEN_CLIENT_URLS="https://${Master_IP}:2379,https://127.0.0.1:2379"

# Server cert
ETCD_CLIENT_CERT_AUTH="true"
ETCD_CERT_FILE="${ETCD_PKI_DIR}/server.pem"
ETCD_KEY_FILE="${ETCD_PKI_DIR}/server-key.pem"
ETCD_TRUSTED_CA_FILE="${ETCD_PKI_DIR}/ca.pem"

# Peer cert
ETCD_PEER_CLIENT_CERT_AUTH="true"
ETCD_PEER_CERT_FILE="${ETCD_PKI_DIR}/peer.pem"
ETCD_PEER_KEY_FILE="${ETCD_PKI_DIR}/peer-key.pem"
ETCD_PEER_TRUSTED_CA_FILE="${ETCD_PKI_DIR}/ca.pem"
EOF

# set etcdctl alias
cat >> $HOME/.bashrc <<EOF
alias ectl='ETCDCTL_API=3 etcdctl --endpoints=${NODE1_IP}:2379,${NODE2_IP}:2379,${NODE3_IP}:2379 --cacert=/etc/etcd/pki/ca.crt --cert=/etc/etcd/pki/server.crt --key=/etc/etcd/pki/server.key'
EOF
source $HOME/.bashrc

systemctl daemon-reload
systemctl enable etcd
systemctl restart etcd
