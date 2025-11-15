## On Ground Station side
```bash
# Start SPIRE Server
bin/spire-server run -config conf/server/server.conf

# Generate token for gndstation
bin/spire-server token generate -spiffeID spiffe://fortress.org/gndstation

# Start SPIRE Agent for gndstation from the token above
bin/spire-agent run -config conf/agent/agent.conf -joinToken <JOIN-TOKEN>

# Register qcontroller as a service on ground station.
bin/spire-server entry create -parentID spiffe://fortress.org/gndstation \
    -spiffeID spiffe://fortress.org/qcontroller -selector unix:uid:1000 -dns fortress.org

# Get certs for the gndstation/qcontroller
bin/spire-agent api fetch x509 -write ../certs/server/
openssl x509 -in ../certs/server/svid.0.pem -text -noout
```


## On Satellite side
```bash
# Generate token for Satellite [This command needs to be run on spire-server]
bin/spire-server token generate -spiffeID spiffe://fortress.org/satellite1

# Start SPIRE Agent for Satellite from the token above
bin/spire-agent run -config conf/agent/agent.conf -joinToken <JOIN-TOKEN>

# Register qcontroller as a service on ground station. [Ensure that the UID matches the user ID of the user where papp is running.
bin/spire-server entry create -parentID spiffe://fortress.org/satellite1 \
    -spiffeID spiffe://fortress.org/papp -selector unix:uid:1013 -dns fortress.org

# Get certs for the satellite/papp
bin/spire-agent api fetch x509 -write ../certs/client/
openssl x509 -in ../certs/client/svid.0.pem -text -noout
```
