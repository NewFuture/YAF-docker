# YAF-docker

[![](https://images.microbadger.com/badges/version/newfuture/yaf.svg)](https://hub.docker.com/r/newfuture/yaf/) [![](https://images.microbadger.com/badges/image/newfuture/yaf.svg)](https://microbadger.com/images/newfuture/yaf "datails")

`newfuture/yaf` : the minimal docker image for yaf extension (current only for php5.6 and default environment is dev )

## Details 

based on alpine (the mini size docke image)

### php5 [![](https://images.microbadger.com/badges/image/newfuture/yaf:php5.6.svg)](https://microbadger.com/images/newfuture/yaf:php5.6 "Get your own image badge on microbadger.com")

* include extensions:
    - [YAF-2.3.5](https://github.com/laruence/yaf)
    - redis-3.1.0
    - memcached
    - memcache
    - PDO-*
    - mcrypt
    - curl
    - gd

### php7 [![](https://images.microbadger.com/badges/image/newfuture/yaf:php7.svg)](https://microbadger.com/images/newfuture/yaf:php7 "Get your own image badge on microbadger.com")

* include extensions:
    - [YAF-3.0.4](https://github.com/laruence/yaf)
    - redis-3.1.0
    - PDO-*
    - mcrypt
    - curl
    - gd


## Usage

* pull image
```
docker pull newfuture/yaf
```
* run your yaf app : replace `"/PATH/OF/YAF/APP/"` with your app path , and it will auto detect public path (if exist `public folder` and not exist `index.php` ,use the `public` as web root
)
```bash
docker run --name yaf -p 1122:80 -v "/PATH/OF/YAF/APP/":/newfuture/yaf newfuture/yaf
```
* just test some php code 
```bash
docker run -it --rm newfuture/yaf php -a
```
* using php7
```bash
docker run -it --rm yaf -p 1122:80 -v "`pwd`":/newfuture/yaf newfuture/yaf:php7
```