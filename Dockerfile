FROM ubuntu:22.04

ARG PYCHARM_BUILD=2022.2.1
ARG pycharm_source=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_BUILD}.tar.gz

RUN apt-get update && apt-get install -y wget gpg \
  && wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg \
  && echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list \
  && apt-get update && apt-get install --no-install-recommends -y \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client less curl nano vim bsdmainutils snapd apt-transport-https \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 libpq-dev \
  # dev-tools
  sudo unzip wget sublime-text terminator git-cola \
  # buser-djangosu
  wait-for-it jq libgdal-dev locales supervisor libmagic-dev build-essential libgeos-dev libffi-dev libxml2-dev libxslt1-dev rustc cargo \
  # && rm -rf /var/lib/apt/lists/* \
  && systemctl enable snapd \
  && groupadd -g 1000 -r developer \
  && useradd -u 1000 -g 1000 -ms /bin/bash -r developer \
  && echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-developer

# pycharm + plugins
WORKDIR /opt/pycharm
RUN curl -fsSL $pycharm_source -o /opt/pycharm/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz \
  && wget https://plugins.jetbrains.com/files/10080/186853/intellij-rainbow-brackets-6.25.zip -O /opt/pycharm/plugins/intellij-rainbow-brackets.zip \
  && unzip /opt/pycharm/plugins/intellij-rainbow-brackets.zip -d /opt/pycharm/plugins \
  && rm /opt/pycharm/plugins/intellij-rainbow-brackets.zip \
  && mkdir -p /opt/pycharm/plugins/monokai-pro-jetbrains/lib \
  && mkdir -p /opt/pycharm/plugins/Statistic/lib \
  && wget https://plugins.jetbrains.com/files/13643/216933/monokai-pro-jetbrains.jar -O /opt/pycharm/plugins/monokai-pro-jetbrains/lib/monokai-pro-jetbrains.jar \
  && wget https://plugins.jetbrains.com/files/4509/215901/Statistic-4.2.3.jar -O /opt/pycharm/plugins/Statistic/lib/Statistic-4.2.3.jar

RUN locale-gen en_US.UTF-8 && \
  dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8

ENV HOME=/home/developer
USER developer
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PATH}:/home/developer/bin:${PYENV_ROOT}/bin" LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR /home/developer

# pyenv e nvm
RUN curl https://pyenv.run | bash \
  && echo 'eval "$(pyenv init -)"' >> /home/developer/.bashrc \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

COPY --chown=developer:developer bin /home/developer/bin
COPY --chown=developer:developer sublime-text /home/developer/.config/sublime-text

CMD [ "/opt/pycharm/bin/pycharm.sh" ]