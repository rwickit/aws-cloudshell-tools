#!/bin/bash

echo "Getting Shell Versions..."
echo(

echo "Bash:"
bash --version
echo(

echo "Z Shell:"
zsh --version
echo(

echo "Powershell (pwsh):"
pwsh --version
echo(

echo "Getting AWS CLI Versions..."
echo(

echo "AWS CLI:"
aws --version
echo(

echo "EB CLI:"
eb --version
echo(

echo "ECS CLI:"
ecs-cli --version
echo(

echo "SAM CLI:"
sam --version
echo(
