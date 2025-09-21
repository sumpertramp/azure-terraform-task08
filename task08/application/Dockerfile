# Multi-stage to keep image small
FROM python:3.11-slim AS base


WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY app.py .


# App will listen on 8080
ENV PORT=8080
EXPOSE 8080
CMD ["python", "app.py"]