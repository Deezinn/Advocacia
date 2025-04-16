FROM alpine:3.21

WORKDIR /app

RUN apk add --no-cache python3 py3-pip py3-virtualenv

RUN python3 -m venv /venv

COPY requirements.txt .

RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

COPY src/ .

CMD ["/venv/bin/python", "index.py"]
