FROM python:3.7-slim-stretch

ARG GIT_SHA
ARG JOB_NUMBER
ARG VERSION

# For running as non-root user
ARG USER=app
ARG GROUP=app
ARG UID=1000
ARG GID=1000
ARG HOME=/usr/src/app

ENV GIT_SHA=${GIT_SHA}
ENV JOB_NUMBER=${JOB_NUMBER}
ENV VERSION=${VERSION}
ENV HOME=${HOME}
ENV FLASK_APP=api.py

# The health check *must* return 0 or 1 so either make sure it does, or you can use the ` || exit 1` trick.
HEALTHCHECK --interval=5s --timeout=5s --retries=3 CMD wget localhost:8080/healthz -q -O - > /dev/null 2>&1

EXPOSE 5000

LABEL MAINTAINER="Ryan Blunden <ryan.blunden@rabbitbird.com>"
LABEL NAME="Python Static Server"
LABEL VERSION="${VERSION}"

RUN mkdir ${HOME} && chown ${UID}:${GID} $HOME \
  && groupadd -g ${GID} ${GROUP} \
  && useradd -d ${HOME} -u ${UID} -g ${GROUP} -m -s /bin/bash ${USER}

WORKDIR /usr/src/app

RUN printf "GIT_SHA=%s\\nJOB_NUMBER=%s\\nVERSION=%s\\n" "${GIT_SHA}" "${JOB_NUMBER}" "${VERSION}" > .properties

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests wget make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install -r requirements.txt && rm -rf ~/.cache/pip/*

USER ${UID}:${GID}

COPY . .

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
