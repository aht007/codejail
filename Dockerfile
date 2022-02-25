FROM ubuntu:focal
SHELL ["/bin/bash", "-c"]

#RUN sysctl -w security=apparmor
# Install Codejail Packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim python3-virtualenv python3-pip
RUN apt-get install -y apparmor-utils sudo

RUN echo "ubuntu ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu
RUN echo "root ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/root && \
    chmod 0440 /etc/sudoers.d/root
RUN echo "sandbox ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/sandbox && \
    chmod 0440 /etc/sudoers.d/sandbox

# Define Environment Variables
ENV CODEJAIL_USER=sandbox
ENV CODEJAIL_GROUP=sandbox
ENV VIRTUALENV_DIR=/home/sandbox/codejail_sandbox-python3.8
ENV CODEJAIL_USER=sandbox
ENV CODEJAIL_SANDBOX_CALLER=ubuntu
ENV APPARMOR_PROFILE=home.sandbox.codejail_sandbox-python3.8.bin.python
ENV CODEJAIL_TEST_USER=sandbox
ENV CODEJAIL_TEST_VENV=/home/sandbox/codejail_sandbox-python3.8

# Create Virtualenv for sandbox user
RUN virtualenv -p python3.8 --always-copy $VIRTUALENV_DIR

RUN virtualenv -p python3.8 venv

# Create Sandbox user & group
RUN addgroup $CODEJAIL_GROUP
RUN adduser --disabled-login --disabled-password $CODEJAIL_USER --ingroup $CODEJAIL_GROUP

USER ubuntu

# Give Ownership of sandbox env to sandbox group
RUN chgrp $CODEJAIL_GROUP $VIRTUALENV_DIR

# Clone Codejail Repo
ADD . ./codejail

WORKDIR /codejail

# Install codejail_sandbox sandbox dependencies
RUN source $VIRTUALENV_DIR/bin/activate && pip install -r requirements/sandbox.txt && deactivate

# Install testing requirements
RUN source /venv/bin/activate && pip install -r requirements/sandbox.txt && pip install -r requirements/testing.txt && deactivate


# Setup sudoers file
ADD apparmor-profiles/01-sandbox /etc/sudoers.d/01-sandbox
RUN chmod 0440 /etc/sudoers.d/01-sandbox

ADD apparmor-profiles/home.sandbox.codejail_sandbox-python3.8.bin.python /etc/apparmor.d/

# Setup Apparmor profile
#ADD apparmor-profiles/home.sandbox.codejail_sandbox-python3.8.bin.python /etc/apparmor.d/
# RUN apparmor_parser -r -W /etc/apparmor.d/home.sandbox.codejail_sandbox-python3.8.bin.python
# RUN aa-enforce /etc/apparmor.d/home.sandbox.codejail_sandbox-python3.8.bin.python
# RUN aa-status

#ADD apparmor-profiles/$APPARMOR_PROFILE /etc/apparmor.d/
#RUN sudo apparmor_parser /etc/apparmor.d/$APPARMOR_PROFILE
#RUN sudo aa-enforce /etc/apparmor.d/$APPARMOR_PROFILE
