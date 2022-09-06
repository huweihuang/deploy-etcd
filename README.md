# install etcd

## 无证书安装

```bash
chmod +x install-etcd.sh

# 在每台机器上以下命令，-m 表示当前执行机器IP, -n 表示当前节点etcd名称，不同节点需要修改这两个参数，其他参数一样。
./install-etcd.sh -a <ip1> -b <ip2> -c <ip3> -m <ip1> -n <etcd_name> -v <version> -d <etcd-data-dir>
```

查看部署状态

```
etcdctl --endpoints=<ip1>:2379,<ip3>:2379,<ip3>:2379 endpoint status -w table

etcdctl --endpoints=<ip1>:2379,<ip3>:2379,<ip3>:2379 put /test test

etcdctl --endpoints=<ip1>:2379,<ip3>:2379,<ip3>:2379 get /test
```

## 有证书安装

> TODO

查看部署状态

```bash
ETCDCTL_API=3 etcdctl --endpoints=<ip1>:2379,<ip3>:2379,<ip3>:2379 --cacert=/etc/etcd/pki/ca.crt --cert=/etc/etcd/pki/server.crt --key=/etc/etcd/pki/server.key endpoint status -w table

# 或者使用别名
alias ectl='ETCDCTL_API=3 etcdctl --endpoints=<ip1>:2379,<ip3>:2379,<ip3>:2379 --cacert=/etc/etcd/pki/ca.crt --cert=/etc/etcd/pki/server.crt --key=/etc/etcd/pki/server.key'

ectl endpoint status -w table
```

# troubleshooting

```json
{"level":"warn","ts":"2022-09-03T18:30:17.536+0800","caller":"embed/config_logging.go:169","msg":"rejected connection","remote-addr":"1.1.1.1:58824","server-name":"","error":"tls: failed to verify client certificate: x509: certificate signed by unknown authority"}
```

