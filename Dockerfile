FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV PATH=$PATH:/usr/local/nginx/sbin

RUN \
	mkdir /src && \
	mkdir /logs && \
	mkdir /vids && \
	mkdir /config && \
	chmod 777 /vids

RUN \
	apt-get update && \
	apt-get upgrade -yq && \
	apt-get clean

RUN \
	apt-get install -yq build-essential wget && \
	apt-get install -yq libpcre3-dev zlib1g-dev libssl-dev && \
	apt-get install -yq ffmpeg

RUN \
	cd /src && \
	wget http://nginx.org/download/nginx-1.11.1.tar.gz && \
	tar zxf nginx-1.11.1.tar.gz && \
	rm nginx-1.11.1.tar.gz

RUN \
	cd /src && \
	wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.8.tar.gz && \
	tar zxf v1.1.8.tar.gz && \
	rm v1.1.8.tar.gz

RUN \
	cd /src/nginx-1.11.1 && \
	./configure --add-module=/src/nginx-rtmp-module-1.1.8 --conf-path=/config/nginx.conf --error-log-path=/logs/error.log --http-log-path=/logs/access.log --with-debug && \
	make && \
	make install

ADD nginx.conf /config/nginx.conf

EXPOSE 80
EXPOSE 1935

VOLUME ["/logs", "/vids"]

CMD "nginx"
