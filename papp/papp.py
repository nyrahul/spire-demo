#!/usr/bin/env python

import httpx

client_cert = ("../certs/client/papp.crt", "../certs/client/papp.key")
ca_cert = "../certs/ca.crt"

response = httpx.get("https://localhost:8000", verify=ca_cert, cert=client_cert)
print(response.json())
