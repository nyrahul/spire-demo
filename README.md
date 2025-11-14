# Steps

## Step1: On Ground Station Node:
```
git clone https://github.com/nyrahul/spire-demo.git
cd spire-demo
./install-spire.sh
./bootstrap-fortress-identities.sh 1000 1013 # 1000 is the UID for QC app, 1013 is the UID for Papp app
```
## Step2: On Ground Station Node, start another terminal:
```
cd spire-demo/spire
bin/spire-agent run -config conf/agent/agent.conf -joinToken 01558ff6-93a0-43e7-8b55-4142b6113f2b # The token is in the context of gndstation
bin/spire-agent api fetch x509 -write ../certs/server/
cd ..
python3 qc.py
```

## Step3: On Satellite1 Node:
```
git clone https://github.com/nyrahul/spire-demo.git
cd spire-demo
./install-spire.sh
bin/spire-agent run -config conf/agent/agent.conf -joinToken 9f96eaea-687b-4b4e-967d-7457ffa83e4f # The token is received during bootstrap procedure on SPIRE server
```

## Step3: On Satellite1 Node, start another terminal:
```
cd spire-demo/spire
bin/spire-agent api fetch x509 -write ../certs/client/
cd ..
python3 papp.py
```
