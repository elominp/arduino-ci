FROM debian:latest
MAINTAINER Guillaume Pirou <guillaume.pirou@epitech.eu>

ENV ARDUINO_VER 1.8.5
ENV DISPLAY :1.0

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN apt update && apt -y install build-essential git xvfb wget xz-utils \
  libxext6 libxtst6 libxrender1 libgtk2.0.0 default-jre libelf-dev \
  gcc-avr avr-libc freeglut3-dev elfutils libelf1 libglib2.0-dev gdb-avr make && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget http://downloads.arduino.cc/arduino-${ARDUINO_VER}-linux64.tar.xz && \
  tar xf arduino-${ARDUINO_VER}-linux64.tar.xz && \
  mv arduino-${ARDUINO_VER} /usr/local/share/arduino && \
  ln -s /usr/local/share/arduino/arduino /usr/local/bin/arduino
  
RUN git clone https://github.com/buserror/simavr.git && \
  cd ./simavr && make && make install ; cd - && rm -rf simavr 
  
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh

RUN ln -s /bin/sh /sh
