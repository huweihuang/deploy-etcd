# install etcd

# 无证书安装

## 部署Etcd集群

```bash
wget https://raw.githubusercontent.com/huweihuang/deploy-etcd/main/install-etcd.sh

# 在每台机器上以下命令，-m 表示当前执行机器IP, -n 表示当前节点etcd名称，不同节点需要修改这两个参数，其他参数一样。<version>和<etcd-data-dir>可不填使用默认值。
bash install-etcd.sh -a <ip1> -b <ip2> -c <ip3> -m <ip1> -n <etcd_name> -v <version> -d <etcd-data-dir>
```

查看部署状态

```bash
etcdctl --endpoints=<ip1>:2379,<ip2>:2379,<ip3>:2379 endpoint status -w table

etcdctl --endpoints=<ip1>:2379,<ip2>:2379,<ip3>:2379 put /test test

etcdctl --endpoints=<ip1>:2379,<ip2>:2379,<ip3>:2379 get /test

# 使用别名
alias ectl='etcdctl --endpoints=<ip1>:2379,<ip2>:2379,<ip3>:2379'
ectl endpoint status -w table
```

## 部署单Etcd节点

```bash
wget https://raw.githubusercontent.com/huweihuang/deploy-etcd/main/install-single-etcd.sh

bash install-single-etcd.sh <host_ip>
```

# 有证书安装

## 安装cfssl

```bash
wget https://raw.githubusercontent.com/huweihuang/deploy-etcd/main/cfssl/install-cfssl.sh

bash install-cfssl.sh
```

## 创建etcd证书

```bash
wget https://raw.githubusercontent.com/huweihuang/deploy-etcd/main/setup-tls.sh

bash setup-tls.sh <ip1> <ip2> <ip3>
```

将`etcd.pki.tgz`的证书上传解压到etcd各节点的/etc/etcd/pki目录下

## 部署etcd集群

```bash
wget https://raw.githubusercontent.com/huweihuang/deploy-etcd/main/install-etcd-with-tls.sh

# 在每台机器上以下命令，-m 表示当前执行机器IP, -n 表示当前节点etcd名称，不同节点需要修改这两个参数，其他参数一样。<version>和<etcd-data-dir>可不填使用默认值。
bash install-etcd-with-tls.sh -a <ip1> -b <ip2> -c <ip3> -m <ip1> -n <etcd_name> -v <version> -d <etcd-data-dir>
```

查看部署状态

```bash
ETCDCTL_API=3 etcdctl --endpoints=<ip1>:2379,<ip2>:2379,<ip3>:2379 --cacert=/etc/etcd/pki/ca.pem --cert=/etc/etcd/pki/server.pem --key=/etc/etcd/pki/server-key.pem endpoint status -w table

# 或者使用别名
alias ectl='ETCDCTL_API=3 etcdctl --endpoints=<ip1>:2379,<ip2>:2379,<ip3>:2379 --cacert=/etc/etcd/pki/ca.pem --cert=/etc/etcd/pki/server.pem --key=/etc/etcd/pki/server-key.pem'

ectl endpoint status -w table
```
