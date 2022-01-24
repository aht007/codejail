FROM python:3.8-alpine

COPY . .

ENV VIRTUAL_ENV='/venvs/codejail_venv'
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python3.8 -m venv "$VIRTUAL_ENV"

RUN pip install -r requirements/tox.txt

ENV CODEJAIL_TEST_USER = 'sandbox'
ENV CODEJAIL_TEST_VENV = "/home/sandbox/codejail_sandbox-python${PYTHON_VERSION}"
