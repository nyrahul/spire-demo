from fastapi import FastAPI
import uvicorn
import ssl

app = FastAPI()

@app.get("/")
def secure_endpoint():
    return {"message": "Hello, Mutual TLS!"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8800, 
				ssl_keyfile="certs/server/svid.0.key",
				ssl_certfile="certs/server/svid.0.pem",
				ssl_ca_certs="certs/server/bundle.0.pem",
				ssl_cert_reqs=ssl.CERT_REQUIRED
			)
