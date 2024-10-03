#!/bin/bash

openssl req -out server.csr -new -newkey rsa:4096 -nodes -keyout server.key -subj "/C=US/ST=NY/L=New York/O=Your Company, Inc./OU=IT/CN=yourdomain.com"
openssl req -new -sha512 -nodes -out server.csr -newkey rsa:4096 -keyout server.key -config <(
cat <<-EOF
[req]
default_bits = 4096
prompt = no
default_md = sha512
days = 365
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=US
ST=New York
L=Rochester
O=End Point
OU=Testing Domain
emailAddress=admin@yourdomain.com
CN = www.yourdomain.com

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = yourdomain.com
DNS.2 = www.yourdomain.com
IP = 1.2.3.4
EOF
)
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt