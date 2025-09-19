import os
from flask import Flask
import redis
import ssl

app = Flask(__name__)

CREATOR = os.getenv("CREATOR", "LOCAL")
REDIS_URL = os.getenv("REDIS_URL")
REDIS_PWD = os.getenv("REDIS_PWD")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6380"))
REDIS_SSL_MODE = os.getenv("REDIS_SSL_MODE", "True").lower() == "true"

r = None
if REDIS_URL and REDIS_PWD:
    if REDIS_SSL_MODE:
        ssl_ctx = ssl.create_default_context()
        r = redis.Redis(host=REDIS_URL, port=REDIS_PORT, password=REDIS_PWD, ssl=True, ssl_cert_reqs=None)
    else:
        r = redis.Redis(host=REDIS_URL, port=REDIS_PORT, password=REDIS_PWD, ssl=False)

@app.route("/")
def index():
    visits = 0
    if r:
        try:
            visits = r.incr("visits")
        except Exception as e:
            return f"Redis connection error: {e}", 500
    msg = "Hello from ACI" if CREATOR == "ACI" else "Hello from K8S"
    return f"{msg} 🚀<br/>Visits: {visits}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
