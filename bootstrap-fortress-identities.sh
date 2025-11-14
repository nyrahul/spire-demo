#!/bin/bash

[ "$2" == "" ] && echo "Usage: $0 <UID for QC> <UID for PAPP>" && exit 1

UID_QC=$1
UID_PAPP=$2

TRUST_DOMAIN="fortress.org"
nc -zv $TRUST_DOMAIN 8081 >/dev/null
[ $? -ne 0 ] && echo "Unable to reach $TRUST_DOMAIN. Ensure that $TRUST_DOMAIN is mapped in /etc/hosts file." \
	&& exit 1

SID_GNDSTN="spiffe://$TRUST_DOMAIN/gndstation"
SID_QC="spiffe://$TRUST_DOMAIN/qcontroller"
SID_SAT1="spiffe://$TRUST_DOMAIN/satellite1"
SID_PAPP="spiffe://$TRUST_DOMAIN/papp"

cd spire
SPIRE_SRV=bin/spire-server
SPIRE_AGT=bin/spire-agent
$SPIRE_SRV healthcheck
[ $? -ne 0 ] && echo "SPIRE Server is not up! Starting up in background ..." && \
				$SPIRE_SRV run -config conf/server/server.conf >spire-server.log 2>&1 &
sleep 2
$SPIRE_SRV healthcheck
[ $? -ne 0 ] && echo "Unable to start up the SPIRE Server!" && exit 2

$SPIRE_SRV entry create \
	-parentID $SID_GNDSTN \
    -spiffeID $SID_QC \
	-selector unix:uid:$UID_QC \
	-dns $TRUST_DOMAIN
[ $? -ne 0 ] && echo "... if the error is about similar entry already exists, then ignore ..."
echo ;

$SPIRE_SRV entry create \
	-parentID $SID_SAT1 \
    -spiffeID $SID_PAPP \
	-selector unix:uid:$UID_PAPP \
	-dns $TRUST_DOMAIN
[ $? -ne 0 ] && echo "... if the error is about similar entry already exists, then ignore ..."
echo ;

echo "Generating join-token for $SID_GNDSTN node SPIRE agent ..."
GNDSTN_JOINTOK=$($SPIRE_SRV token generate -spiffeID $SID_GNDSTN -output json | jq .value -r)
[ $? -ne 0 ] && echo "Could not generate join token for $SID_GNDSTN" && exit 2
echo "Start SPIRE Agent for $SID_GNDSTN using following command:"
echo "$SPIRE_AGT run -config conf/agent/agent.conf -joinToken $GNDSTN_JOINTOK"
echo ;

echo "Generating join-token for $SID_SAT1 node SPIRE agent ..."
SAT1_JOINTOK=$($SPIRE_SRV token generate -spiffeID $SID_SAT1 -output json | jq .value -r)
[ $? -ne 0 ] && echo "Could not generate join token for $SID_SAT1" && exit 2
echo "Start SPIRE Agent for $SID_SAT1 using following command:"
echo "$SPIRE_AGT run -config conf/agent/agent.conf -joinToken $SAT1_JOINTOK"

