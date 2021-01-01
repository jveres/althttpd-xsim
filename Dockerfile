FROM alpine:3.10 as build
ARG SQLITE_ID="1d984722"

RUN apk add --no-cache git ca-certificates alpine-sdk wget

RUN wget https://sqlite.org/althttpd/tarball/53cafeffe4/althttpd-${ALTHTTPD_ID}.tar.gz
RUN tar xzf althttpd-${ALTHTTPD_ID}.tar.gz

WORKDIR /althttpd-${ALTHTTPD_ID}
RUN cc -static -Os -Wall -Wextra -o althttpd althttpd.c
RUN strip althttpd
RUN echo "www:x:65534:65534:www:/:" > /etc/passwd

FROM scratch
COPY --from=build /althttpd-${ALTHTTPD_ID}/althttpd /usr/local/bin/
COPY --from=build /etc/passwd /etc/passwd
USER www
CMD ["althttpd", "-port", "8080", "-root", "/", "-user", "www", "-logfile", "/proc/1/fd/1"]