from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
def secure_endpoint():
    return {"message": "Hello, Mutual TLS!"}

if __name__ == "__main__":
#    ssl_context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
#    ssl_context.load_cert_chain("../certs/server/qcontroller.crt", "../certs/server/qcontroller.key")
#    ssl_context.load_verify_locations("../certs/ca.crt")
#    ssl_context.verify_mode = ssl.CERT_REQUIRED
    uvicorn.run(app, host="0.0.0.0", port=8000, 
				ssl_keyfile="../certs/server/qcontroller.key",
				ssl_certfile="../certs/server/qcontroller.crt"
			)
