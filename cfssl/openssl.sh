#!/bin/bash

pem_name=$1

# 确认 Issuer 字段的内容和 ca-csr.json 一致；
# 确认 Subject 字段的内容和 ca-csr.json 一致；
# 确认 X509v3 Subject Alternative Name 字段的内容和 ca-csr.json 一致；

openssl x509  -noout -text -in ${pem_name}
