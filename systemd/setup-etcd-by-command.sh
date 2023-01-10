etcd --name=etcd01 \
--data-dir=/data/etcd \
--listen-client-urls=https://${NODE1_IP}:2379,http://127.0.0.1:2379 \
--advertise-client-urls=https://${NODE1_IP}:2379 \
--listen-peer-urls=https://${NODE1_IP}:2380 \
--initial-advertise-peer-urls=https://${NODE1_IP}:2380 \
--initial-cluster-token=etcd-cluster-0 \
--initial-cluster etcd01=https://${NODE1_IP}:2380,etcd02=https://${NODE2_IP}:2380,etcd03=https://${NODE3_IP}:2380 \
--initial-cluster-state new \
--auto-tls=true \
--cert-file=/etc/etcd/pki/server.pem \
--key-file=/etc/etcd/pki/server-key.pem \
--client-cert-auth=true \
--trusted-ca-file=/etc/etcd/pki/ca.pem \
--peer-auto-tls=true \
--peer-cert-file=/etc/etcd/pki/peer.pem \
--peer-key-file=/etc/etcd/pki/peer-key.pem \
--peer-client-cert-auth=true \
--peer-trusted-ca-file=/etc/etcd/pki/ca.pem


etcd --name=etcd02 \
--data-dir=/data/etcd \
--listen-client-urls=https://${NODE2_IP}:2379,http://127.0.0.1:2379 \
--advertise-client-urls=https://${NODE2_IP}:2379 \
--listen-peer-urls=https://${NODE2_IP}:2380 \
--initial-advertise-peer-urls=https://${NODE2_IP}:2380 \
--initial-cluster-token=etcd-cluster-0 \
--initial-cluster etcd01=https://${NODE1_IP}:2380,etcd02=https://${NODE2_IP}:2380,etcd03=https://${NODE3_IP}:2380 \
--initial-cluster-state new \
--auto-tls=true \
--cert-file=/etc/etcd/pki/server.pem \
--key-file=/etc/etcd/pki/server-key.pem \
--client-cert-auth=true \
--trusted-ca-file=/etc/etcd/pki/ca.pem \
--peer-auto-tls=true \
--peer-cert-file=/etc/etcd/pki/peer.pem \
--peer-key-file=/etc/etcd/pki/peer-key.pem \
--peer-client-cert-auth=true \
--peer-trusted-ca-file=/etc/etcd/pki/ca.pem


etcd --name=etcd03 \
--data-dir=/data/etcd \
--listen-client-urls=https://${NODE3_IP}:2379,http://127.0.0.1:2379 \
--advertise-client-urls=https://${NODE3_IP}:2379 \
--listen-peer-urls=https://${NODE3_IP}:2380 \
--initial-advertise-peer-urls=https://${NODE3_IP}:2380 \
--initial-cluster-token=etcd-cluster-0 \
--initial-cluster etcd01=https://${NODE1_IP}:2380,etcd02=https://${NODE2_IP}:2380,etcd03=https://${NODE3_IP}:2380 \
--initial-cluster-state new \
--auto-tls=true \
--cert-file=/etc/etcd/pki/server.pem \
--key-file=/etc/etcd/pki/server-key.pem \
--client-cert-auth=true \
--trusted-ca-file=/etc/etcd/pki/ca.pem \
--peer-auto-tls=true \
--peer-cert-file=/etc/etcd/pki/peer.pem \
--peer-key-file=/etc/etcd/pki/peer-key.pem \
--peer-client-cert-auth=true \
--peer-trusted-ca-file=/etc/etcd/pki/ca.pem

