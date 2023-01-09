#!/bin/bash
set -ex

NODE1_IP=$1
NODE2_IP=$2
NODE3_IP=$3

CERT_DIR="./pki"
rm -fr ${CERT_DIR} etcd.pki.tgz
mkdir -p ${CERT_DIR}
cd ${CERT_DIR}

cat > ca-config.json << EOF
{
    "signing":{
        "default":{
            "expiry":"876000h"
        },
        "profiles":{
            "etcd":{
                "usages":[
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ],
                "expiry":"876000h"
            }
        }
    }
}
EOF

cat > ca-csr.json << EOF
{
    "CN": "etcd",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "SH",
            "L": "SH",
            "O": "etcd",
            "OU": "System"
        }
    ]
}
EOF

cat > etcd-csr.json << EOF
{
    "CN": "etcd",
    "hosts": [
        "localhost",
        "127.0.0.1",
        "${NODE1_IP}",
        "${NODE2_IP}",
        "${NODE3_IP}"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "SH",
            "L": "SH",
            "O": "etcd",
            "OU": "System"
        }
    ]
}
EOF

# 生成服务端证书
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=etcd etcd-csr.json | cfssljson -bare server
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=etcd etcd-csr.json | cfssljson -bare peer


cat > client.json <<EOF
{
    "CN": "client",
    "key": {
            "algo": "rsa",
            "size": 2048
    }
}
EOF

# 生成客户端证书
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=etcd client.json  | cfssljson -bare client

# 打包
cd ..
tar -zcvf etcd.pki.tgz ./pki

# 将证书上传到etcd各节点的/etc/etcd/pki目录下
