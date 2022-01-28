FROM ubuntu:focal

RUN apt-get update && apt-get install -y python3-virtualenv

COPY . .

ENV VIRTUAL_ENV="/home/sandbox/codejail_sandbox-python38"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN virtualenv -p python3.8 --always-copy "$VIRTUAL_ENV"

RUN pip install -r requirements/sandbox.txt
