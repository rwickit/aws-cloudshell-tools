#!/bin/bash

echo "Updating AWS CLI v2..."
echo(
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q -o awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
echo(
echo "AWS CLI v2 updated!"
