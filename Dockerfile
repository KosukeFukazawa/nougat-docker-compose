FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,rw apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*
RUN --mount=type=cache,target=/root/.cache/pip,rw \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN mkdir /app
WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/pip,rw \
    pip3 install fastapi uvicorn[standard] fsspec[http]==2023.1.0 python-multipart tokenizers
COPY ./ .
RUN --mount=type=cache,target=/root/.cache/pip,rw \
    python3 setup.py install

EXPOSE ${CONTAINER_PORT}

CMD uvicorn app:app --host 0.0.0.0 --port ${CONTAINER_PORT}