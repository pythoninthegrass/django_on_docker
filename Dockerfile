# syntax=docker/dockerfile:1.7

FROM python:3.11.9-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN rm -f /etc/apt/apt.conf.d/docker-clean

ARG DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update -qq \
    && apt-get install -qq --no-install-recommends -y \
        apt-utils \
        ca-certificates \
        git \
        netcat \
        sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

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

ARG USER_NAME=appuser
ARG USER_UID=${UID:-1000}
ARG USER_GID=${GID:-$USER_UID}

RUN groupadd --gid $USER_GID $USER_NAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER_NAME \
    && mkdir -p /etc/sudoers.d \
    && echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME \
    && chmod 0440 /etc/sudoers.d/$USER_NAME

USER $USER_NAME

ENTRYPOINT ["/app/entrypoint.sh"]
CMD [ "--dev" ]
