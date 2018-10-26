FROM ubuntu:18.04

WORKDIR /usr/src/app

RUN apk add ca-certificates && \
    rm -rf /var/cache/apk/* && \
    \
    wget https://github.com/garethr/kubeval/releases/download/0.7.3/kubeval-linux-amd64.tar.gz && \
    tar xzf kubeval-linux-amd64.tar.gz -C /usr/local/bin && \
    rm kubeval-linux-amd64.tar.gz &&
    \
    wget -O /usr/local/bin/kubectl wget https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl && \
    \
    cat >/root/.bashrc <<KUBESEC
kubesec ()
{
    local FILE="${1:-}";
    [[ ! -f "${FILE}" ]] && {
        echo "kubesec: ${FILE}: No such file" >&2;
        return 1
    };
    curl --silent \
      --compressed \
      --connect-timeout 5 \
      -F file=@"${FILE}" \
      https://kubesec.io/
}
KUBESEC








