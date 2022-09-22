#!/bin/bash
if [[ ! -d ~/.buserdev ]]; then
  mkdir -p ~/.buserdev
  cid=$(docker create tonylampada/buserdev)
  docker cp $cid:/home/developer ~/.buserdev
  docker rm -v $cid
else 
  # echo nop
  cid=$(docker create tonylampada/buserdev)
  # docker cp $cid:/home/developer ~/.buserdev
  docker rm -v $cid
fi

xhost +local:docker

PARAMS=""

# git e ssh
PARAMS="$PARAMS
  -v $HOME/.ssh:/home/developer/.ssh
  -v $HOME/.gitconfig:/home/developer/.gitconfig
  -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent
  -e SSH_AUTH_SOCK=/ssh-agent
"
# magica pra acessar programas graficos
PARAMS="$PARAMS
  -e DISPLAY=$DISPLAY
  -v /tmp/.X11-unix:/tmp/.X11-unix
"


# se for usar o android-studio com emulador, mete um --privileged aí
docker run -d --rm --net=host --privileged --name=buserdev $PARAMS \
  -v ~/.buserdev/home:/home/developer \
  -v ~/work:/home/developer/work \
  tonylampada/buserdev terminator # terminator, bash, pycharm... o q vc quiser
