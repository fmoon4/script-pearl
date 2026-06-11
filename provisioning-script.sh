#!/bin/bash
set -euo pipefail

DATA_DIRECTORY="${DATA_DIRECTORY:-/workspace/}"
MINER_DIR="${DATA_DIRECTORY%/}/srbminer"

POOL="${POOL:?Missing POOL env var}"
WALLET="${WALLET:?Missing WALLET env var}"
WORKER="${WORKER:?Missing WORKER env var}"
ALGO="${ALGO:-pearlhash}"
PASSWORD="${PASSWORD:-x}"
MINER_URL="${MINER_URL:?Missing MINER_URL env var}"

mkdir -p "$MINER_DIR"
cd "$MINER_DIR"

apt-get update
apt-get install -y curl ca-certificates unzip tar file

curl -fL "$MINER_URL" -o miner.tar.gz

if file miner.tar.gz | grep -qi 'gzip'; then
  tar -xf miner.tar.gz
else
  echo "Downloaded file is not a tar.gz archive"
  file miner.tar.gz
  exit 1
fi

MINER_BIN="$(find "$MINER_DIR" -maxdepth 3 -type f \( -name 'SRBMiner-MULTI' -o -name 'SRBMiner-Multi' -o -name 'SRBMiner-Multi-Linux' \) | head -n 1)"

if [ -z "$MINER_BIN" ]; then
  echo "Miner binary not found in $MINER_DIR"
  find "$MINER_DIR" -maxdepth 3 -type f
  exit 1
fi

chmod +x "$MINER_BIN"

exec "$MINER_BIN" \
  --algorithm "$ALGO" \
  --pool "$POOL" \
  --wallet "$WALLET" \
  --worker "$WORKER" \
  --password "$PASSWORD"
