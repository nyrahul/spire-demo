#!/bin/bash

if ! command -v openssl >/dev/null 2>&1; then
	echo "openssl tool not found. please install and rerun ..."
	exit
fi

BDIR=certs
SRVDIR=$BDIR/server
CLIDIR=$BDIR/client

mkdir -p $SRVDIR $CLIDIR

echo "generating root CA keys ..."
openssl req -x509 -new -nodes -keyout $BDIR/ca.key -out $BDIR/ca.crt -days 365 -subj "/CN=kali"

# Generate Qcontroller keys -----------------------------------------
echo "generating keys for Qcontroller ..."
openssl genrsa -out $SRVDIR/qcontroller.key 2048

# Create a Certificate Signing Request (CSR) for the Server
openssl req -new -key $SRVDIR/qcontroller.key -out $SRVDIR/qcontroller.csr -subj "/CN=localhost" \
		-addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

# Sign the Server Certificate with the CA
openssl x509 -req -in $SRVDIR/qcontroller.csr \
		-CA $BDIR/ca.crt -CAkey $BDIR/ca.key -CAcreateserial \
		-out $SRVDIR/qcontroller.crt -days 365
# --------------------------------------------------------------------

# Generate papp keys -------------------------------------------------
echo "generating keys for Papp ..."
openssl genrsa -out $CLIDIR/papp.key 2048

# Create a Certificate Signing Request (CSR) for the Client
openssl req -new -key $CLIDIR/papp.key -out $CLIDIR/papp.csr -subj "/CN=localhost" \
		-addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

# Sign the Client Certificate with the CA
openssl x509 -req -in $CLIDIR/papp.csr \
		-CA $BDIR/ca.crt -CAkey $BDIR/ca.key -CAcreateserial \
		-out $CLIDIR/papp.crt -days 365
# --------------------------------------------------------------------
