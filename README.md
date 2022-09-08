# buserdev

Estou experimentando com a ideia de ter um "ambdev como código" - uma imagem docker que já tem pyenv, pycharm e as coisas instalados com o apt que os projetos precisem

Constrói a imagem (ou faz um docker pull)

```
./build.sh
# ou
docker pull tonylampada/buseredev
```

Crie um script de inicialização do seu ambiente assim:

```
#!/bin/bash
if [[ ! -d ~/.buserdev ]]; then
  mkdir -p ~/.buserdev/.cache ~/.buserdev/.config ~/.buserdev/.java ~/.buserdev/.local
  cid=$(docker create buserdev)
  docker cp $cid:/home/developer/.bashrc ~/.buserdev/.bashrc
  docker cp $cid:/home/developer/.pyenv ~/.buserdev/.pyenv
  docker rm -v $cid
fi

xhost +local:docker
docker run -it --rm -e DISPLAY=$DISPLAY --net=host --name=buserdev \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/work:/home/developer/work \
  -v ~/.ssh:/home/developer/.ssh \
  -v ~/.buserdev/.cache:/home/developer/.cache \
  -v ~/.buserdev/.config:/home/developer/.config \
  -v ~/.buserdev/.java:/home/developer/.java \
  -v ~/.buserdev/.local:/home/developer/.local \
  -v ~/.buserdev/.bashrc:/home/developer/.bashrc \
  -v ~/.buserdev/.pyenv:/home/developer/.pyenv \
  buserdev bash
```