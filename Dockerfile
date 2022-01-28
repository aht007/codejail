FROM ubuntu:focal

RUN apt update && apt-get install -y software-properties-common && \
  apt install -y apt-transport-https ca-certificates pkg-config ligffi-dev libsqlite3-dev libfreetype6-dev libpq-dev

COPY . .

ENV VIRTUAL_ENV="/home/sandbox/codejail_sandbox-python38"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN virtualenv -p python3.8 --always-copy "$VIRTUAL_ENV"

RUN pip install -r requirements/sandbox.txt
