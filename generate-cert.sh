#!/bin/bash

openssl req -x509 -newkey rsa:2048 -keyout appgw-cert.key -out appgw-cert.crt -days 365 -nodes \
  -subj "/C=JP/ST=Tokyo/L=Tokyo/O=Test/CN=*.example.com"

openssl pkcs12 -export -out appgw-cert.pfx -inkey appgw-cert.key -in appgw-cert.crt -passout pass:P@ssw0rd123

echo "Certificate created: appgw-cert.pfx (password: P@ssw0rd123)"
