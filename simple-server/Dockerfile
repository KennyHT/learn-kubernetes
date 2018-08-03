FROM python:3.7-slim

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get upgrade -y  && \
    apt-get install -y --no-install-recommends curl nano jq less groff && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install pip setuptools --upgrade --trusted-host pypi.python.org --trusted-host pypi.org --trusted-host files.pythonhosted.org && \
    pip install -r requirements.txt --trusted-host pypi.python.org --trusted-host pypi.org --trusted-host files.pythonhosted.org && \
    rm -fr /root/.cache

COPY . .

EXPOSE 8080

CMD ["python", "-u", "server.py"]
