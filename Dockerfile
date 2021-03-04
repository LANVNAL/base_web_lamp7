FROM ubuntu:16.04
MAINTAINER lanvnal

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update sources
RUN apt-get update -y

# install http
RUN apt-get install -y apache2 vim net-tools
RUN mkdir -p /var/lock/apache2 /var/run/apache2

# install mysql
RUN echo debconf mysql-server/root_password password root > /tmp/mysql-passwd && echo debconf mysql-server/root_password_again password root >> /tmp/mysql-passwd
RUN apt-get update -y && debconf-set-selections /tmp/mysql-passwd && apt-get install -yqq mysql-server  && rm -rf /var/lib/apt/lists/*
RUN apt-get install -y mysql-server \
    &&apt update && apt-get install -y  php php7.0-mysql php7.0-curl libapache2-mod-php7.0

#RUN echo "NETWORKING=yes" > /etc/sysconfig/network apt install libapache2-mod-php7.0
# start mysqld to create initial tables
#RUN service mysqld start


# install supervisord

# RUN apt-get install -y supervisor
# RUN mkdir -p /var/log/supervisor

COPY src/start.sh /start.sh
RUN chmod a+x /start.sh

EXPOSE 80
WORKDIR /var/www/html
CMD ["/start.sh"]

