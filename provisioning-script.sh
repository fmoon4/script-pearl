#!/bin/bash
set -euo pipefail

POOL="${POOL:?Missing POOL}"
WALLET="${WALLET:?Missing WALLET}"
WORKER="${WORKER:?Missing WORKER}"
ALGO="${ALGO:-pearlhash}"
PASSWORD="${PASSWORD:-x}"
MINER_DIR="${MINER_DIR:-/workspace/srbminer}"

apt-get update
apt-get install -y curl ca-certificates unzip tar

mkdir -p "$MINER_DIR"
cd "$MINER_DIR"

curl -fsSL "https://miner.download/en/srbminer" -o srbminer-download

if file srbminer-download | grep -qi 'zip'; then
  unzip -o srbminer-download
elif file srbminer-download | grep -qiE 'tar|gzip'; then
  tar -xf srbminer-download
fi

MINER_BIN="$(find "$MINER_DIR" -type f \( -name 'SRBMiner-MULTI' -o -name 'SRBMiner-MULTI.exe' \) | head -n 1)"
chmod +x "$MINER_BIN"

exec "$MINER_BIN" \
  --algorithm "$ALGO" \
  --pool "$POOL" \
  --wallet "$WALLET.$WORKER" \
  --password "$PASSWORD" \
  --disable-cpu
