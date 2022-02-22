FROM ubuntu:focal
SHELL ["/bin/bash", "-c"]

# Install Codejail Packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim python3-virtualenv python3-pip python3-dev python3-venv
RUN apt-get install -y apparmor-utils sudo

# Define Environment Variables
ENV CODEJAIL_USER=sandbox
ENV CODEJAIL_GROUP=sandbox
ENV VIRTUALENV_DIR=/home/sandbox/codejail_sandbox-python3.8
ENV CODEJAIL_USER=sandbox
ENV CODEJAIL_SANDBOX_CALLER=ubuntu
ENV APPARMOR_PROFILE=home.sandbox.codejail_sandbox-python3.8.bin.python
ENV CODEJAIL_TEST_USER=sandbox
ENV CODEJAIL_TEST_VENV=/home/sandbox/codejail_sandbox-python3.8
ENV VIRTUAL_ENV=/home/sandbox/codejail_sandbox-python3.8
RUN python3.8 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Create Sandbox user & group
RUN addgroup $CODEJAIL_GROUP
RUN adduser --disabled-login --disabled-password $CODEJAIL_USER --ingroup $CODEJAIL_GROUP

# Give Ownership of sandbox env to sandbox group
RUN chgrp $CODEJAIL_GROUP $VIRTUAL_ENV


# Clone Codejail Repo
ADD . ./codejail

WORKDIR /codejail

# RUN pip install -r requirements/tox.txt
RUN pip install -r requirements/testing.txt
RUN pip install -r requirements/sandbox.txt

# Install codejail_sandbox sandbox dependencies
#RUN source $VIRTUALENV_DIR/bin/activate && pip install -r requirements/sandbox.txt

# Setup sudoers file
ADD apparmor-profiles/01-sandbox /etc/sudoers.d/

# Setup Apparmor profile
#ADD apparmor-profiles/home.sandbox.codejail_sandbox-python3.8.bin.python /etc/apparmor.d/
#RUN apparmor_parser -r -W /etc/apparmor.d/home.sandbox.codejail_sandbox-python3.8.bin.python
#RUN aa-enforce /etc/apparmor.d/home.sandbox.codejail_sandbox-python3.8.bin.python
#RUN aa-status

#ADD apparmor-profiles/$APPARMOR_PROFILE /etc/apparmor.d/
#RUN sudo apparmor_parser /etc/apparmor.d/$APPARMOR_PROFILE
#RUN sudo aa-enforce /etc/apparmor.d/$APPARMOR_PROFILE