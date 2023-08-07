#!/bin/bash

# Set the hostname of the Docker daemon's host
HOST=`ip route get 1 | awk '{print $7}'`
CERTS_DIR=./docker-certificates

# Create a directory to store keys and certificates
mkdir -p $CERTS_DIR

# Generate CA private and public keys
openssl genrsa -aes256 -out $CERTS_DIR/ca-key.pem 4096
openssl req -new -x509 -days 365 -key $CERTS_DIR/ca-key.pem -sha256 -out $CERTS_DIR/ca.pem -subj "/CN=$HOST"

# Generate server key and certificate signing request (CSR)
openssl genrsa -out $CERTS_DIR/server-key.pem 4096
openssl req -subj "/CN=$HOST" -sha256 -new -key $CERTS_DIR/server-key.pem -out $CERTS_DIR/server.csr

# Create an extensions config file for server
echo "subjectAltName = DNS:$HOST,IP:$HOST,IP:127.0.0.1" > $CERTS_DIR/extfile.cnf
echo "extendedKeyUsage = serverAuth" >> $CERTS_DIR/extfile.cnf

# Generate the signed server certificate
openssl x509 -req -days 365 -sha256 -in $CERTS_DIR/server.csr -CA $CERTS_DIR/ca.pem -CAkey $CERTS_DIR/ca-key.pem -CAcreateserial -out $CERTS_DIR/server-cert.pem -extfile $CERTS_DIR/extfile.cnf

# Generate client key and certificate signing request (CSR)
openssl genrsa -out $CERTS_DIR/key.pem 4096
openssl req -subj '/CN=client' -new -key $CERTS_DIR/key.pem -out $CERTS_DIR/client.csr

# Create an extensions config file for client
echo "extendedKeyUsage = clientAuth" > $CERTS_DIR/extfile-client.cnf

# Generate the signed client certificate
openssl x509 -req -days 365 -sha256 -in $CERTS_DIR/client.csr -CA $CERTS_DIR/ca.pem -CAkey $CERTS_DIR/ca-key.pem -CAcreateserial -out $CERTS_DIR/cert.pem -extfile $CERTS_DIR/extfile-client.cnf

# Remove temporary files
rm -v $CERTS_DIR/client.csr $CERTS_DIR/server.csr $CERTS_DIR/extfile.cnf $CERTS_DIR/extfile-client.cnf

# Set proper permissions
chmod -v 0400 $CERTS_DIR/ca-key.pem $CERTS_DIR/key.pem $CERTS_DIR/server-key.pem
chmod -v 0444 $CERTS_DIR/ca.pem $CERTS_DIR/server-cert.pem $CERTS_DIR/cert.pem

echo "Keys and certificates generated successfully in the ${CERTS_DIR} folder!"
