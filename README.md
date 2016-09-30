# YAF-docker

[![](https://images.microbadger.com/badges/version/newfuture/yaf.svg)](https://hub.docker.com/r/newfuture/yaf/)
[![](https://images.microbadger.com/badges/image/newfuture/yaf.svg)](https://microbadger.com/images/newfuture/yaf "datails")

`newfuture/yaf` : the minimal docker image for yaf extension (current only for php5.6 and default environment is dev )

## Details 
* based on alpine (the mini size docke image)
* include extensions:
    - [YAF](https://github.com/laruence/yaf)
    - redis
    - memcached
    - memcache
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
```
docker run -it --rm newfuture/yaf php -a
```