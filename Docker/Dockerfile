FROM ubuntu:focal

USER root

## package update
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y openssl

## Set "Noninteractive" mode during Docker build
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
## locales: Doop may hang for non-UTF8 locales
RUN apt-get install -y apt-utils busybox nano libterm-readline-perl-perl
# apt-utils installation should happen before locales installation
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN dpkg-reconfigure --frontend=noninteractive locales

## Souffle
RUN apt-get install -y cmake cpp autoconf automake bison build-essential clang doxygen flex g++ gdb git libncurses5-dev libtool libsqlite3-dev make mcpp python3 sqlite unzip zlib1g-dev wget curl
# RUN mkdir /souffle && wget https://github.com/souffle-lang/souffle/releases/download/1.5.1/souffle_1.5.1-1_amd64.deb -O /souffle/souffle_1.5.1-1_amd64.deb && apt-get install /souffle/souffle_1.5.1-1_amd64.deb
RUN mkdir /souffle && wget https://github.com/souffle-lang/souffle/releases/download/2.4/x86_64-ubuntu-2004-souffle-2.4-Linux.deb -O /souffle/souffle-2.4-Linux.deb && apt-get install /souffle/souffle-2.4-Linux.deb

## Doop
RUN apt-get install -y openjdk-8-jdk openjdk-8-jre openjdk-8-jdk-headless radare2 unzip time maven
RUN git clone https://bitbucket.org/yanniss/doop-benchmarks.git
ENV DOOP_BENCHMARKS=/doop-benchmarks
ENV DOOP_PLATFORMS_LIB=/doop-benchmarks
ENV DOOP_CACHE=/data/cache
ENV DOOP_OUT=/data/out

## Install Doop
RUN git clone https://github.com/plast-lab/doop-mirror.git /doop  && cd /doop && git checkout temp-push-to-mirror && ./gradlew installDist
ENV DOOP_HOME=/doop/build/install/doop
ENV PATH="$PATH:$DOOP_HOME/bin"

## Revert to "Dialog" mode after Docker build
RUN echo 'debconf debconf/frontend select Dialog' | debconf-set-selections