FROM ubuntu:focal

RUN apt update && \
  apt-get install -y software-properties-common && \
  apt-add-repository -y ppa:deadsnakes/ppa && apt-get update && \
  apt install -y git-core language-pack-en python3.8-dev python3.8-venv libmysqlclient-dev libffi-dev libssl-dev build-essential gettext openjdk-8-jdk && \
  rm -rf /var/lib/apt/lists/*

COPY . .

ENV VIRTUAL_ENV='/venvs/codejail_venv'
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python3.8 -m venv "$VIRTUAL_ENV"

RUN pip install -r requirements/tox.txt

ENV CODEJAIL_TEST_USER = 'sandbox'
ENV CODEJAIL_TEST_VENV = "/home/sandbox/codejail_sandbox-python${PYTHON_VERSION}"
