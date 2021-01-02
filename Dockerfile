FROM alpine:3.10 as builder
ARG SQLITE_ID="1d984722"

RUN apk add --no-cache git ca-certificates alpine-sdk wget

RUN wget https://sqlite.org/althttpd/tarball/53cafeffe4/althttpd-${ALTHTTPD_ID}.tar.gz
RUN tar xzf althttpd-${ALTHTTPD_ID}.tar.gz

WORKDIR /althttpd-${ALTHTTPD_ID}
# allow run as root
RUN sed -i. 's/if( getuid()==0 ){/if( 0 ){/' althttpd.c
RUN cc -static -Os -Wall -Wextra -o althttpd althttpd.c
RUN strip althttpd
    
FROM scratch
COPY --from=builder /althttpd-${ALTHTTPD_ID}/althttpd /usr/local/bin/
CMD ["althttpd", "-port", "8080", "-root", "/", "-logfile", "/dev/console"]