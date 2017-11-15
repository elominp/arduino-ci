FROM gitlab/gitlab-runner:ubuntu
MAINTAINER Guillaume Pirou <guillaume.pirou@epitech.eu>

ENV ARDUINO_VER 1.8.5

RUN apt update && apt -y install build-essential git xvfb wget xz-utils \
  libxext6 libxtst6 libxrender1 libgtk2.0.0 default-jre libelf-dev \
  gcc-avr avr-libc freeglut3-dev elfutils libelf1 libglib2.0-dev gdb-avr make && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget http://downloads.arduino.cc/arduino-${ARDUINO_VER}-linux64.tar.xz && \
  tar xf arduino-${ARDUINO_VER}-linux64.tar.xz && \
  mv arduino-${ARDUINO_VER} /usr/local/share/arduino && \
  ln -s /usr/local/share/arduino/arduino /usr/local/bin/arduino && \
  rm -rf arduino-${ARDUINO_VER}-linux64.tar.xz
  
RUN git clone https://github.com/buserror/simavr.git && \
  cd ./simavr && make && make install ; cd - && rm -rf simavr 
  
# COPY ./entrypoint.sh /entrypoint
