FROM ubuntu:22.04

ARG PYCHARM_BUILD=2022.2.1
ARG pycharm_source=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_BUILD}.tar.gz
ARG ANDROID_STUDIO_URL=https://dl.google.com/dl/android/studio/ide-zips/2021.3.1.16/android-studio-2021.3.1.16-linux.tar.gz
ARG ANDROID_CMDLINETOOLS_URL=https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget gpg nautilus
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg \
  && wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg \
  && echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list \
  && echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list \
  && apt-get update && apt-get install --no-install-recommends -y \
  python3 python3-dev python3-setuptools python3-pip dart \
  gcc git openssh-client less curl nano vim bsdmainutils apt-transport-https openjdk-11-jdk qemu qemu-kvm \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 libpq-dev libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev \
  # dev-tools
  sudo zip unzip file sublime-text terminator git-cola gitk meld nautilus \
  # buser-django
  wait-for-it jq libgdal-dev locales supervisor libmagic-dev build-essential libgeos-dev libffi-dev libxml2-dev libxslt1-dev rustc cargo \
  # && rm -rf /var/lib/apt/lists/* \
  && apt-get clean && rm -rf /tmp/* /var/tmp/*
RUN apt-get install --no-install-recommends -y xdg-utils fonts-liberation android-sdk-platform-tools-common \ 
  && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && dpkg -i google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb
RUN locale-gen en_US.UTF-8 \
  && dpkg-reconfigure locales \
  && locale-gen C.UTF-8 \
  && /usr/sbin/update-locale LANG=C.UTF-8 \
  && groupadd -g 1000 -r developer \
  && useradd -u 1000 -g 1000 -ms /bin/bash -r developer \
  && echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-developer \
  && adduser developer kvm \
  && adduser developer plugdev

# pycharm + plugins
WORKDIR /opt/pycharm
RUN curl -fsSL $pycharm_source -o /opt/pycharm/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz \
  && wget https://plugins.jetbrains.com/files/10080/186853/intellij-rainbow-brackets-6.25.zip -O /opt/pycharm/plugins/intellij-rainbow-brackets.zip \
  && wget https://plugins.jetbrains.com/files/18824/217056/CodeGlance_Pro-1.5.0-signed.zip -O /opt/pycharm/plugins/CodeGlance_Pro.zip \
  && unzip /opt/pycharm/plugins/intellij-rainbow-brackets.zip -d /opt/pycharm/plugins \
  && unzip /opt/pycharm/plugins/CodeGlance_Pro.zip -d /opt/pycharm/plugins \
  && rm /opt/pycharm/plugins/intellij-rainbow-brackets.zip \
  && rm /opt/pycharm/plugins/CodeGlance_Pro.zip \
  && mkdir -p /opt/pycharm/plugins/monokai-pro-jetbrains/lib \
  && mkdir -p /opt/pycharm/plugins/Statistic/lib \
  && wget https://plugins.jetbrains.com/files/13643/216933/monokai-pro-jetbrains.jar -O /opt/pycharm/plugins/monokai-pro-jetbrains/lib/monokai-pro-jetbrains.jar \
  && wget https://plugins.jetbrains.com/files/4509/215901/Statistic-4.2.3.jar -O /opt/pycharm/plugins/Statistic/lib/Statistic-4.2.3.jar

# android studio
# WORKDIR /opt
# RUN wget $ANDROID_STUDIO_URL -O android-studio.tar.gz \
#  && tar xzvf android-studio.tar.gz \
#  && rm android-studio.tar.gz
# && mv android-studio androidstudio # /opt/android-studio dá match com um "well known path" do FVM e o flutter quebra pq não consegue deixar de usar o java 1.8 que tem lá. Esse rename eh uma gambi pra resolver isso. 

USER developer
WORKDIR /home/developer

ENV HOME=/home/developer LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8 ANDROID_SDK_ROOT=/home/developer/Android/Sdk ANDROID_HOME=/home/developer/Android/Sdk
ENV PYENV_ROOT="${HOME}/.pyenv" 
ENV PATH="${PATH}:${HOME}/bin:${PYENV_ROOT}/bin:${HOME}/.pub-cache/bin:./.fvm/flutter_sdk/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/emulator:${ANDROID_SDK_ROOT}/platform-tools"

# Android SDK
RUN wget $ANDROID_CMDLINETOOLS_URL -O commandlinetools-linux-latest.zip \
  && unzip commandlinetools-linux-latest.zip \
  && rm commandlinetools-linux-latest.zip \
  && mkdir -p /home/developer/Android/Sdk/cmdline-tools \
  && mv cmdline-tools latest \
  && mv latest /home/developer/Android/Sdk/cmdline-tools/ \
  && yes | sdkmanager platform-tools emulator

# pyenv, nvm
RUN sudo mv /bin/sh /bin/origsh && sudo ln -s /bin/bash /bin/sh
RUN curl https://pyenv.run | bash \
  && echo 'eval "$(pyenv init -)"' >> /home/developer/.bashrc \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
  && . ~/.nvm/nvm.sh && nvm install --lts \
  && sudo rm /bin/sh && sudo mv /bin/origsh /bin/sh

# fvm
RUN dart pub global activate fvm

COPY --chown=developer:developer bin /home/developer/bin
COPY --chown=developer:developer .config /home/developer/.config
COPY --chown=developer:developer .gradle /home/developer/.gradle

CMD [ "/bin/bash" ]
