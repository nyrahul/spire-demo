import ssl
import uvicorn
from fastapi import FastAPI

app = FastAPI()

# 1. Build your custom SSL context
ssl_context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
ssl_context.load_verify_locations("../certs/ca.crt")
ssl_context.load_cert_chain("../certs/server/qcontroller.crt", "../certs/server/qcontroller.key")
ssl_context.verify_mode = ssl.CERT_REQUIRED

# 2. Create Uvicorn config WITHOUT ssl args
config = uvicorn.Config(
    app,
    host="0.0.0.0",
    port=8000,
)

# 3. Create server and inject your custom SSL context
server = uvicorn.Server(config)
server.ssl_context = ssl_context
server.run()

