FROM python:3.11.9-slim-bullseye

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -qqy --no-install-recommends \
        netcat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

ENV PIP_CACHE_DIR=/root/.cache/pip
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100

RUN mkdir -p "$PIP_CACHE_DIR"

RUN --mount=type=cache,target=/root/.cache/pip \
    python3 -m pip install --upgrade pip setuptools \
    && python3 -m pip install -r requirements.txt

COPY ./app/entrypoint.sh .

COPY ./app .

CMD ["/app/entrypoint.sh"]
