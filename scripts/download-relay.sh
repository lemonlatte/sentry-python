#!/bin/bash
set -e

if { [ "$TRAVIS" == "true" ] || [ "$TF_BUILD" == "True" ]; } && [ -z "$GITHUB_API_TOKEN" ]; then
    echo "Not running on external pull request"
    exit 0;
fi

target=relay

# Download the latest relay release for Travis

output="$(
    curl -s \
    https://api.github.com/repos/getsentry/relay/releases/latest?access_token=$GITHUB_API_TOKEN
)"

echo "$output"

output="$(echo "$output" \
    | grep "$(uname -s)" \
    | grep -v "\.zip" \
    | grep "download" \
    | cut -d : -f 2,3 \
    | tr -d , \
    | tr -d \")"

echo "$output"
echo "$output" | wget -i - -O $target
[ -s $target ]
chmod +x $target
