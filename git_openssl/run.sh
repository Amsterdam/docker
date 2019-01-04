#!/usr/bin/env bash

set -u   # crash on missing env variables
set -e   # stop on any error
set -x

source /etc/lsb-release
echo "DISTRIB_RELEASE is:" $DISTRIB_RELEASE
echo "DISTRIB_CODENAME is:" $DISTRIB_CODENAME

docker-compose build --build-arg MAJOR_MINOR=$DISTRIB_RELEASE --build-arg CODE_NAME=$DISTRIB_CODENAME --no-cache
docker-compose up --force-recreate
docker cp "$(docker-compose ps -q)":/tmp/source-git/deb/ .
sudo dpkg -i deb/git-man*ubuntu$DISTRIB_RELEASE*.deb
sudo dpkg -i deb/git_*ubuntu$DISTRIB_RELEASE.1_amd64.deb
docker-compose down --rmi all
