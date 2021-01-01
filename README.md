# althttpd-xsim
Super tiny static web server Docker image based on Sqlite/Althttpd

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/jveres/althttpd-xsim)

# Usage
```sh
docker build -t althttpd .

docker run --rm -v `pwd`/default.website:/default.website -p8080:8080 althttpd
```