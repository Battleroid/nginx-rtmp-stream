FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV PATH=$PATH:/usr/local/nginx/sbin

RUN \
	mkdir /src && \
	mkdir /logs && \
	mkdir /vids && \
	mkdir /config

RUN \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get clean

RUN \
	apt-get install -y build-essential wget && \
	apt-get install -y libpcre3-dev zlib1g-dev libssl-dev && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:mc3man/trusty-media && \
	apt-get update && \
	apt-get install -y ffmpeg

RUN \
	cd /src && \
	wget http://nginx.org/download/nginx-1.6.2.tar.gz && \
	tar zxf nginx-1.6.2.tar.gz && \
	rm nginx-1.6.2.tar.gz

RUN \
	cd /src && \
	wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.6.tar.gz && \
	tar zxf v1.1.6.tar.gz && \
	rm v1.1.6.tar.gz

RUN \
	cd /src/nginx-1.6.2 && \
	./configure --add-module=/src/nginx-rtmp-module-1.1.6 --conf-path=/config/nginx.conf --error-log-path=/logs/error.log --http-log-path=/logs/access.log && \
	make && \
	make install

ADD nginx.conf /config/nginx.conf

EXPOSE 80
EXPOSE 1935

VOLUME ["/logs", "/vids"]

CMD "nginx"
