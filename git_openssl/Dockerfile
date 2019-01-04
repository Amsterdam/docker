ARG MAJOR_MINOR
FROM ubuntu:${MAJOR_MINOR}
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install software-properties-common build-essential fakeroot dpkg-dev -y
RUN add-apt-repository ppa:git-core/ppa
ARG CODE_NAME
RUN printf "deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu ${CODE_NAME} main\n" >> /etc/apt/sources.list.d/git-core-ubuntu-ppa-bionic.list \
	&& apt update
RUN apt-get build-dep git -y
RUN apt-get install libcurl4-openssl-dev -y
WORKDIR /tmp/source-git
RUN apt-get source git
RUN cd git-* && sed -i -- 's/libcurl4-gnutls-dev/libcurl4-openssl-dev/' ./debian/control \
	&& sed -i -- '/TEST\s*=\s*test/d' ./debian/rules \
	&& dpkg-buildpackage -rfakeroot -b
WORKDIR /tmp/source-git/deb
ARG MAJOR_MINOR
RUN cp /tmp/source-git/git_*ubuntu${MAJOR_MINOR}.*_amd64.deb . \
	&& cp /tmp/source-git/git-man* .