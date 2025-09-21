import os
from flask import Flask
import redis


app = Flask(__name__)


CREATOR = os.getenv("CREATOR", "LOCAL")
REDIS_HOST = os.getenv("REDIS_URL", "localhost")
REDIS_PWD = os.getenv("REDIS_PWD", "")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6380"))
REDIS_SSL = os.getenv("REDIS_SSL_MODE", "True").lower() in ("1","true","yes")


r = None
if REDIS_HOST:
  r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PWD, ssl=REDIS_SSL, ssl_cert_reqs=None)


@app.route("/")
def root():
  try:
    visits = r.incr("visits") if r else 0
  except Exception:
    visits = -1
  prefix = "Hello from ACI" if CREATOR == "ACI" else ("Hello from K8S" if CREATOR == "K8S" else "Hello")
  return f"{prefix}! Visits: {visits}\n"


if __name__ == "__main__":
  app.run(host="0.0.0.0", port=int(os.getenv("PORT","8080")))