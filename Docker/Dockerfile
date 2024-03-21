FROM ubuntu:focal

USER root

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

## package update
RUN apt-get update && apt-get install -y apt-utils openssl openssh-server openjdk-8-jdk openjdk-8-jre openjdk-8-jdk-headless radare2 unzip time maven tmux wget curl

## SSH
RUN sed -i "s/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g" /etc/ssh/sshd_config && sed -i "s/#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config && echo root:password | chpasswd

## Souffle
RUN mkdir /souffle && cd /souffle && wget https://souffle-lang.github.io/ppa/souffle-key.public -O /usr/share/keyrings/souffle-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/souffle-archive-keyring.gpg] https://souffle-lang.github.io/ppa/ubuntu/ stable main" | tee /etc/apt/sources.list.d/souffle.list
RUN apt-get update && apt-get install -y souffle 

## Set "Noninteractive" mode during Docker build
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
## locales: Doop may hang for non-UTF8 locales
RUN apt-get install -y apt-utils busybox nano libterm-readline-perl-perl
# apt-utils installation should happen before locales installation
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN dpkg-reconfigure --frontend=noninteractive locales

## Doop
RUN apt-get install -y git
RUN git clone https://bitbucket.org/yanniss/doop-benchmarks.git /doop-benchmarks
ENV DOOP_BENCHMARKS=/doop-benchmarks
ENV DOOP_PLATFORMS_LIB=/doop-benchmarks
ENV DOOP_CACHE=/data/cache
ENV DOOP_OUT=/data/out

## Install Doop
RUN git clone https://github.com/fe1w0/doop-mirror.git /doop  && cd /doop && git checkout temp-push-to-mirror && ./gradlew installDist
ENV DOOP_HOME=/doop/build/install/doop
ENV PATH="$PATH:$DOOP_HOME/bin"

## Clean
RUN apt-get clean

## Revert to "Dialog" mode after Docker build
RUN echo 'debconf debconf/frontend select Dialog' | debconf-set-selections