FROM alpine as buildbox

WORKDIR /usr/local/app
COPY . .

RUN apk add --no-cache \
    fuse-dev asciidoc make gcc syslinux-dev musl-dev

RUN cc -Wall -Wno-unused-function -Wconversion -Wtype-limits -DUSE_AUTH -D_XOPEN_SOURCE=700 -D_ISOC99_SOURCE \
      -g -Os -Wall -I/usr/include/fuse  -D_FILE_OFFSET_BITS=64   httpfs2.c -lfuse -o httpfs2

# for smallest image
FROM alpine
RUN apk add --no-cache \
    fuse
COPY --from=buildbox /usr/local/app/httpfs2 /usr/local/bin/httpfs2custom
