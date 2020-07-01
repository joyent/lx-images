#!/usr/bin/env bash

set -xe
cd ubuntu

export UBUNTU_RELEASE=20.04

tar="lx-ubuntu-$UBUNTU_RELEASE.tar"
tag="release:$$"

docker build --tag "$tag" \
	--build-arg UBUNTU_RELEASE="$UBUNTU_RELEASE" .

container=$(docker create $tag)
docker cp "$container":/ -> "$tar"
docker rm "$container"
docker rmi "$tag"

echo "Created $PWD/$tar"
