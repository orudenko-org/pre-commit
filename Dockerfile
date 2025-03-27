# syntax=docker/dockerfile:1

FROM python:3.12-alpine3.21

ENV PATH=/home/jenkins/cache/.venv/bin:/home/jenkins/.local/bin:$PATH
ENV PIPENV_VENV_IN_PROJECT=1

RUN --mount=type=cache,target=/var/cache/apk <<EOF
  apk update
  apk upgrade
  apk add git
EOF

RUN adduser -D -G dialout -u 501 jenkins

USER jenkins

RUN --mount=type=cache,target=/home/jenkins/.cache/pip,uid=501,gid=20 <<EOF
  pip install --upgrade pip setuptools wheel
  pip install pipenv==2024.4.1
EOF

WORKDIR /home/jenkins/cache

COPY --chown=jenkins:dialout ["Pipfile", "Pipfile.lock", "./"]

RUN --mount=type=cache,target=/home/jenkins/.cache/pipenv,uid=501,gid=20 <<EOF
  pipenv install --dev --ignore-pipfile
EOF

COPY --chown=jenkins:dialout [".pre-commit-config.yaml", "./"]

RUN <<EOF
  git config --global safe.directory '*'
  git init --quiet
  pre-commit install-hooks
EOF

VOLUME /home/jenkins/workspace

WORKDIR /home/jenkins/workspace
