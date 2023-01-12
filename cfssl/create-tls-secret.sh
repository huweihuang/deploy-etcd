#!/bin/bash
set -ex

NAMESPACE=$1
ETCD_CERT_NAME="etcd-tls-secret"
WORK_DIR="/etc/etcd/pki"

kubectl create secret generic ${ETCD_CERT_NAME} \
--from-file=ca.pem=${WORK_DIR}/ca.pem \
--from-file=client.pem=${WORK_DIR}/client.pem \
--from-file=client-key.pem=${WORK_DIR}/client-key.pem -n ${NAMESPACE}
