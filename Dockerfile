FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV PATH=$PATH:/usr/local/nginx/sbin

RUN mkdir /src && mkdir /config && mkdir /logs

EXPOSE 1935
EXPOSE 80

RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y build-essential wget

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:mc3man/trusty-media
RUN apt-get update
RUN apt-get install -y ffmpeg

RUN apt-get install -y libpcre3-dev zlib1g-dev libssl-dev
RUN apt-get install -y wget

RUN cd /src && wget http://nginx.org/download/nginx-1.6.2.tar.gz && tar zxf nginx-1.6.2.tar.gz && rm nginx-1.6.2.tar.gz

RUN cd /src && wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.6.tar.gz && tar zxf v1.1.6.tar.gz && rm v1.1.6.tar.gz

RUN cd /src/nginx-1.6.2 && ./configure --add-module=/src/nginx-rtmp-module-1.1.6 --conf-path=/config/nginx.conf --error-log-path=/logs/error.log --http-log-path=/logs/access.log
RUN cd /src/nginx-1.6.2 && make && make install

ADD nginx.conf /config/nginx.conf

CMD "nginx"
