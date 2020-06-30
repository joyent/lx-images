#!/usr/bin/env bash

set -xe
cd centos

export CENTOS_RELEASE=8

tar="lx-centos-$CENTOS_RELEASE.tar"
tag="release:$$"

docker build --tag "$tag" \
	--build-arg CENTOS_RELEASE="$CENTOS_RELEASE" .

container=$(docker create $tag)
docker cp "$container":/ -> "$tar"
docker rm "$container"
docker rmi "$tag"

echo "Created $PWD/$tar"
