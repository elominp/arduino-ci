FROM ubuntu:14.04
MAINTAINER Guillaume Pirou <guillaume.pirou@epitech.eu>

ENV ARDUINO_VER 1.8.5

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates apt-transport-https vim nano \
    build-essential git xvfb wget xz-utils \
    libxext6 libxtst6 libxrender1 libgtk2.0.0 default-jre libelf-dev \
    gcc-avr avr-libc freeglut3-dev elfutils libelf1 libglib2.0-dev gdb-avr make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN wget http://downloads.arduino.cc/arduino-${ARDUINO_VER}-linux64.tar.xz && \
    tar xf arduino-${ARDUINO_VER}-linux64.tar.xz && \
    mv arduino-${ARDUINO_VER} /usr/local/share/arduino && \
    ln -s /usr/local/share/arduino/arduino /usr/local/bin/arduino && \
    rm -rf arduino-${ARDUINO_VER}-linux64.tar.xz
  
RUN git clone https://github.com/buserror/simavr.git && \
    cd ./simavr && make && make install ; cd - && rm -rf simavr
    
COPY gitlab-runner_amd64.deb /tmp/

ADD entrypoint /
RUN chmod +x /entrypoint

RUN dpkg -i /tmp/gitlab-runner_amd64.deb; \
    apt-get update && \
    apt-get -f install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/gitlab-runner_amd64.deb && \
    gitlab-runner --version && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    wget -q https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    docker-machine --version && \
    wget -q https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 -O /usr/bin/dumb-init && \
    chmod +x /usr/bin/dumb-init && \
    dumb-init --version

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
