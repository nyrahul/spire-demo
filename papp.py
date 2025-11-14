#!/usr/bin/env python

import httpx

client_cert = ("certs/client/svid.0.pem", "certs/client/svid.0.key")
ca_cert = "../certs/server/bundle.0.pem"

response = httpx.get("https://fortress.org:8800", verify=ca_cert, cert=client_cert)
print(response.json())
