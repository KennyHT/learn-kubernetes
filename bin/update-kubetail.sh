#!/usr/bin/env bash

echo "[info]: Downloading latest kubetail script..."
curl --silent --location --output /tmp/kubetail.tar.gz $(curl https://api.github.com/repos/johanhaleby/kubetail/releases/latest | jq -r .tarball_url)
tar -xzf /tmp/kubetail.tar.gz -C /tmp/
cp /tmp/johanhaleby-kubetail*/kubetail ./bin/
unlink /tmp/kubetail.tar.gz
