#!/bin/bash

[ "$(uname)" != "Linux" ] && echo "works only for linux." && exit 2

SPIRE_SRV=spire/bin/spire-server
SPIRE_AGT=spire/bin/spire-agent

killall spire-server 2>/dev/null

# Install SPIRE
[ -d spire ] && echo "Deleting existing SPIRE installation ..." && rm -rf spire
echo "Installing SPIRE ..."
curl -s -N -L https://github.com/spiffe/spire/releases/download/v1.13.3/spire-1.13.3-linux-amd64-musl.tar.gz | tar xz
mv spire-1.13.3 spire
[ ! -f spire/bin/spire-server ] && echo "spire could not be installed" && exit 3

# Change trust domain to fortress.org
echo "Updating Trust Domain ..."
sed -i -e 's/example\.org/fortress\.org/g' \
	   -e 's/bind_address = "127.0.0.1"/bind_address = "0.0.0.0"/g' \
	   spire/conf/server/server.conf
sed -i -e 's/example\.org/fortress\.org/g' \
	   -e 's/server_address = "localhost"/server_address = "fortress.org"/g' \
	   spire/conf/agent/agent.conf

mkdir -p certs/server
mkdir -p certs/client
echo "SPIRE installed successfully."
