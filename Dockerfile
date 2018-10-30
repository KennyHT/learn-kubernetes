FROM alpine:3.8

WORKDIR /usr/src/app

RUN apk add ca-certificates wget && \
    rm -rf /var/cache/apk/*

RUN wget https://github.com/garethr/kubeval/releases/download/0.7.3/kubeval-linux-amd64.tar.gz && \
    tar xzf kubeval-linux-amd64.tar.gz -C /usr/local/bin && \
    rm kubeval-linux-amd64.tar.gz

# RUN wget -O /usr/local/bin/kubectl wget https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl

COPY bin /usr/local/bin

RUN ls -l /usr/local/bin


