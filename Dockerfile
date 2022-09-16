FROM ubuntu:22.04

ARG PYCHARM_BUILD=2022.2.1
ARG pycharm_source=https://download.jetbrains.com/python/pycharm-community-${PYCHARM_BUILD}.tar.gz
ARG ANDROID_STUDIO_URL=https://dl.google.com/dl/android/studio/ide-zips/3.5.3.0/android-studio-ide-191.6010548-linux.tar.gz
ARG ANDROID_CMDLINETOOLS_URL=https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget gpg nautilus \
  && wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg \
  && echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list \
  && apt-get update && apt-get install --no-install-recommends -y \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client less curl nano vim bsdmainutils snapd apt-transport-https openjdk-11-jdk qemu qemu-kvm \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 libpq-dev libglu1-mesa \
  # dev-tools
  sudo zip unzip file sublime-text terminator git-cola gitk meld nautilus \
  # buser-djangosu
  wait-for-it jq libgdal-dev locales supervisor libmagic-dev build-essential libgeos-dev libffi-dev libxml2-dev libxslt1-dev rustc cargo \
  # && rm -rf /var/lib/apt/lists/* \
  && systemctl enable snapd \
  && groupadd -g 1000 -r developer \
  && useradd -u 1000 -g 1000 -ms /bin/bash -r developer \
  && echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-developer \
  && adduser developer kvm

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
WORKDIR /opt
RUN wget $ANDROID_STUDIO_URL -O android-studio.tar.gz \
 && tar xzvf android-studio.tar.gz \
 && rm android-studio.tar.gz \
 && mv android-studio androidstudio # /opt/android-studio dá match com um "well known path" do FVM e o flutter quebra pq não consegue deixar de usar o java 1.8 que tem lá. Esse rename eh uma gambi pra resolver isso. 

RUN locale-gen en_US.UTF-8 \
  && dpkg-reconfigure locales \
  && locale-gen C.UTF-8 \
  && /usr/sbin/update-locale LANG=C.UTF-8

# Flutter
# sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.1-stable.tar.xz \
  && tar xvf flutter_linux_3.3.1-stable.tar.xz \
  && rm flutter_linux_3.3.1-stable.tar.xz

ENV HOME=/home/developer
USER developer
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PATH}:/home/developer/bin:/home/developer/Android/Sdk/tools:${PYENV_ROOT}/bin:/home/developer/Android/Sdk/cmdline-tools/latest/bin:/home/developer/.pub-cache/bin:.fvm/flutter_sdk/bin:/opt/flutter/bin" LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR /home/developer

# Android SDK
RUN wget $ANDROID_CMDLINETOOLS_URL -O commandlinetools-linux-latest.zip \
  && unzip commandlinetools-linux-latest.zip \
  && rm commandlinetools-linux-latest.zip \
  && mkdir -p /home/developer/Android/Sdk/cmdline-tools \
  && mv cmdline-tools latest \
  && mv latest /home/developer/Android/Sdk/cmdline-tools/ \
  && yes | sdkmanager "platforms;android-25" "build-tools;25.0.2" "extras;google;m2repository" "extras;android;m2repository" \
  && dart pub global activate fvm \
  && fvm install 3.0.4

# pyenv e nvm
RUN sudo mv /bin/sh /bin/origsh && sudo ln -s /bin/bash /bin/sh
RUN curl https://pyenv.run | bash \
  && echo 'eval "$(pyenv init -)"' >> /home/developer/.bashrc \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
  && . ~/.nvm/nvm.sh && nvm install --lts \
  && sudo rm /bin/sh && sudo mv /bin/origsh /bin/sh

COPY --chown=developer:developer bin /home/developer/bin
COPY --chown=developer:developer sublime-text /home/developer/.config/sublime-text

CMD [ "/opt/pycharm/bin/pycharm.sh" ]
