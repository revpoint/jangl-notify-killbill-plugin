FROM ubuntu:20.04
LABEL maintainer="tech@jangl.com"

USER root

ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=C
ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=utf8

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      apt-utils \
      build-essential \
      curl \
      git \
      less \
      libaio1 \
      libapr1 \
      libcurl4 \
      libcurl4-openssl-dev \
      libmysqlclient-dev \
      libnuma1 \
      libpq-dev \
      maven \
      mysql-client \
      net-tools \
      openjdk-8-jdk-headless \
      postgresql-client \
      python3-lxml \
      software-properties-common \
      sudo \
      telnet \
      unzip \
      zip \
      vim && \
    apt-add-repository -y ppa:rael-gc/rvm && \
    apt-get update && \
    apt-get install --no-install-recommends -y rvm && \
    rm -rf /var/lib/apt/lists/*

# Configure default JAVA_HOME path
RUN update-java-alternatives -s java-1.8.0-openjdk-amd64
RUN rm -f /usr/lib/jvm/default-java && ln -s java-8-openjdk-amd64 /usr/lib/jvm/default-java
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV JSSE_HOME=$JAVA_HOME/jre/

# Setup Maven
RUN mkdir -p /root/.m2

WORKDIR /plugin/
RUN echo 0.0.0 > VERSION
COPY Gemfile Gemfile.lock Jarfile Jarfile.lock killbill-jangl-notify.gemspec ./

COPY Taskfile .
RUN ./Taskfile install-ruby
RUN ./Taskfile install-deps

ENTRYPOINT ["./Taskfile"]
CMD ["build"]
