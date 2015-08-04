#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: create-swap.sh <amount of MB>"
  exit 1
fi

if [ -e /mnt/swap ]; then
  echo "/mnt/swap already exists" >&2
  exit 1
fi

# This scipt tries to put a 1gb swap partition on an 8gb drive. Once
# spark is built, that leaves us with a few hundred meg free. If the /mnt/swap
# file already exists, it doesn't try, so we just touch the file and deal with
# swap ourselves.
touch /mnt/swap

SWAP_MB=1024

dd if=/dev/zero of=/vol0/swap bs=1M count=$SWAP_MB
dd if=/dev/zero of=/vol1/swap bs=1M count=$SWAP_MB

mkswap /vol0/swap
mkswap /vol1/swap

chmod 600 /vol0/swap
chmod 600 /vol1/swap

swapon /vol0/swap
swapon /vol1/swap
