FROM python:3.7-slim-stretch

ARG GIT_SHA
ARG JOB_NUMBER
ARG VERSION

ENV GIT_SHA=${GIT_SHA}
ENV JOB_NUMBER=${JOB_NUMBER}
ENV VERSION=${VERSION}

RUN printf "GIT_SHA=${GIT_SHA}\nJOB_NUMBE${JOB_NUMBER}\nVERSION=${VERSION}\n" > .properties

LABEL MAINTAINER="Ryan Blunden <ryan.blunden@rabbitbird.com>"
LABEL NAME="Python Static Server"
LABEL VERSION="${VERSION}"

WORKDIR /usr/src/app

RUN apt-get update && apt-get install make && apt-get clean

COPY requirements.txt .
RUN pip install -r requirements.txt && rm -rf ~/.cache/pip/*

COPY . .

#
# The health check *must* return 0 or 1 so either make sure it does, or you can use the ` || exit 1` trick.
HEALTHCHECK --interval=5s --timeout=5s --retries=3 CMD wget localhost:8080/healthz -q -O - > /dev/null 2>&1

EXPOSE 5000

ENV FLASK_APP=api.py

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
