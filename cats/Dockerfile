FROM python:3.7-slim-stretch

# For running as non-root user
ARG USER=app
ARG GROUP=app
ARG UID=1000
ARG GID=1000
ARG HOME=/usr/src/app

WORKDIR /usr/src/app

RUN chown ${UID}:${GID} $HOME \
  && groupadd -g ${GID} ${GROUP} \
  && useradd -d ${HOME} -u ${UID} -g ${GROUP} -m -s /bin/bash ${USER}

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests wget make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ARG GIT_SHA
ARG JOB_NUMBER
ARG VERSION

ENV GIT_SHA=${GIT_SHA}
ENV JOB_NUMBER=${JOB_NUMBER}
ENV VERSION=${VERSION}
ENV HOME=${HOME}
ENV FLASK_APP=app.py

RUN printf "GIT_SHA=%s\\nJOB_NUMBER=%s\\nVERSION=%s\\n" "${GIT_SHA}" "${JOB_NUMBER}" "${VERSION}" > .properties

USER ${UID}:${GID}

COPY . .

# The health check *must* return 0 or 1 so either make sure it does, or you can use the ` || exit 1` trick.
HEALTHCHECK --interval=5s --timeout=5s --retries=3 CMD wget localhost:5000/healthz -q -O - > /dev/null 2>&1 || exit 1

EXPOSE 5000

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
