## 安装cfssl

```bash
wget https://raw.githubusercontent.com/huweihuang/deploy-etcd/main/cfssl/install-cfssl.sh

bash install-cfssl.sh
```

## 创建etcd证书

```bash
wget https://raw.githubusercontent.com/huweihuang/deploy-etcd/main/cfssl/gen-cert.sh.sh

bash gen-cert.sh <ip1> <ip2> <ip3>
```
