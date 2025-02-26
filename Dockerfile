FROM alpine:latest AS builder
WORKDIR /root

RUN apk add --no-cache git make build-base && \
    git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git && \
    cd vlmcsd/ && \
    make

RUN mkdir /tmp/frp && \
    cd /tmp/frp && \
    ver=$(wget --no-check-certificate -qO- https://api.github.com/repos/fatedier/frp/releases/latest | grep 'tag_name' | cut -d\" -f4) && \
    frp_ver="frp_$(echo ${ver} | sed -e 's/^[a-zA-Z]//g')" && \
    wget --no-check-certificate "https://github.com/fatedier/frp/releases/download/${ver}/${frp_ver}_linux_amd64.tar.gz" && \
    tar zxf ${frp_ver}_linux_amd64.tar.gz && \
    mv /tmp/frp/${frp_ver}_linux_amd64/frps /usr/local/bin/frps && \
    chmod +x /usr/local/bin/frps

FROM alpine:latest
LABEL maintainer="jalena@bcsytv.com"
WORKDIR /root/
COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd
COPY --from=builder /usr/local/bin/frps /usr/bin/frps
RUN apk add --update supervisor && \
    mkdir -p /var/logs/ && \
    rm -rf /tmp/* /var/cache/apk/*

COPY conf.d/supervisord.conf /etc/supervisord.conf

EXPOSE 1688
EXPOSE 7000
EXPOSE 7500

ENTRYPOINT [ "supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf" ]