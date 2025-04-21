#!/bin/bash
set -e

echo "[+] Cleaning up"
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
