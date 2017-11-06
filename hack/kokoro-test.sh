#!/bin/bash
set -ex

echo "Installing dependencies..."

# shellcheck source=/dev/null
source "$KOKORO_GFILE_DIR/common.sh"

# Grab the latest version of shellcheck and add it to PATH
if [ -f "$KOKORO_GFILE_DIR"/shellcheck-latest.linux ]; then
    sudo cp "$KOKORO_GFILE_DIR"/shellcheck-latest.linux /usr/local/bin/shellcheck
    sudo cp "$KOKORO_GFILE_DIR"/shellcheck-latest.linux /usr/local/bin/shellcheck
    sudo chmod +x /usr/local/bin/shellcheck
fi

pushd github/runtimes-common
# Install deps.
sudo pip install --upgrade -r requirements.txt

echo "Running unit tests..."
# Run the tests.
./test.sh

echo "Running integration tests..."
gcloud container builds submit --config ftl/ftl_node_integration_tests.yaml .
