FROM ubuntu:14.10
MAINTAINER Marek Dabrowski <marek@dabrowski.me>

RUN apt-get -qqy update
RUN apt-get -qqy upgrade
RUN apt-get -qqy install apache2-utils squid3 openssh-server

RUN cd /usr/local/src/
RUN wget https://www.shrew.net/download/ike/ike-2.2.1-release.tbz2
RUN tar jxpvf ike-2.2.1-release.tbz2 
RUN cd ike
RUN apt-get -y install cmake libqt4-core libqt4-dev libqt4-gui libedit-dev libssl-dev checkinstall flex bison
cmake -DCMAKE_INSTALL_PREFIX=/usr -DQTGUI=YES -DETCDIR=/etc -DNATT=YES /usr/local/src/ike
checkinstall -y
RUN mv /etc/iked.conf.sample /etc/iked.conf

RUN mkdir /usr/etc

EXPOSE 3128
VOLUME /var/log/squid3

ADD init /init
ADD ike.vpn /etc/ike.vpn
CMD ["/init"]
