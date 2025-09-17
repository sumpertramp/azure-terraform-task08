import os
from flask import Flask
import redis

app = Flask(__name__)

REDIS_HOST = os.getenv("REDIS_URL", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6380"))
REDIS_PWD  = os.getenv("REDIS_PWD", "")
REDIS_SSL  = os.getenv("REDIS_SSL_MODE", "True").lower() == "true"
CREATOR    = os.getenv("CREATOR", "LOCAL")

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PWD, ssl=REDIS_SSL)

@app.route("/")
def index():
    try:
        visits = r.incr("visits")
    except Exception as e:
        return f"Redis connection error: {e}", 500

    if CREATOR == "ACI":
        hello = "Hello from ACI"
    elif CREATOR == "K8S":
        hello = "Hello from K8S"
    else:
        hello = "Hello from LOCAL"

    return f"""
    <h1>{hello}</h1>
    <p>Visits: {visits}</p>
    """, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
