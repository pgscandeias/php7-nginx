# php7-nginx docker image

What it says on the tin.

Includes nginx, php7 and is ready to talk to mysql, postgres and mongo. Installed extensions:

- php7.0-fpm 
- php7.0-cli 
- php7.0-xml 
- php7.0-gd 
- php7.0-mcrypt 
- php7.0-intl 
- php7.0-mysql 
- php7.0-pgsql 
- php7.0-curl 
- php7.0-dev 
- php7.0-mbstring 
- php7.0-zip 
- php-pear 

To run the container:

```shell
docker run pgscandeias/php7-nginx
```


Tanks to:

- http://phusion.github.io/baseimage-docker/ for the base image
- https://github.com/fideloper/docker-nginx-php for inspiration
- https://github.com/php the php team
- https://github.com/nginx the nginx team

