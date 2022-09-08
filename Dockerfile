FROM ubuntu:22.04

ARG PYCHARM_VERSION=2022.2
ARG PYCHARM_BUILD=2022.2.1
ARG pycharm_source=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_BUILD}.tar.gz
ARG pycharm_local_dir=.PyCharmCE${PYCHARM_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client less curl nano vim \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 libpq-dev \
  # dev-tools
  terminator git-cola \
  # buser-django
  wait-for-it jq libgdal-dev locales supervisor libmagic-dev build-essential libgeos-dev libffi-dev libxml2-dev libxslt1-dev rustc cargo \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer


WORKDIR /opt/pycharm

RUN curl -fsSL $pycharm_source -o /opt/pycharm/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PATH}:/home/developer/bin:${PYENV_ROOT}/bin"
WORKDIR /home/developer
COPY --chown=developer:developer bin /home/developer/bin

RUN curl https://pyenv.run | bash
RUN echo 'eval "$(pyenv init -)"' >> /home/developer/.bashrc

# RUN mkdir /home/developer/.PyCharm && ln -sf /home/developer/.PyCharm /home/developer/$pycharm_local_dir

CMD [ "/opt/pycharm/bin/pycharm.sh" ]