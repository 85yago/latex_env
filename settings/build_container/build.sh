#!/bin/sh

docker buildx build --builder mybuilder --platform linux/amd64,linux/arm64 -t yagoyagoyago/latex_env:latest --push .
