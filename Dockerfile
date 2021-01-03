FROM alpine:3.10
ARG SQLITE_ID="1d984722"

RUN apk add --no-cache git ca-certificates alpine-sdk wget

RUN wget https://sqlite.org/althttpd/tarball/53cafeffe4/althttpd-${ALTHTTPD_ID}.tar.gz
RUN tar xzf althttpd-${ALTHTTPD_ID}.tar.gz

WORKDIR /althttpd-${ALTHTTPD_ID}
RUN cc -static -Os -Wall -Wextra -o althttpd althttpd.c
RUN strip althttpd
RUN echo "nobody:x:65534:65534:nobody:/:" > /etc/passwd
    
FROM scratch
COPY --from=0 /althttpd-${ALTHTTPD_ID}/althttpd /usr/local/bin/
COPY --from=0 /etc/passwd /etc/passwd
USER nobody
CMD ["althttpd", "-port", "8080", "-root", "/", "-logfile", "/dev/stderr"]