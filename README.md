# buserdev

Estou experimentando com a ideia de ter um "ambdev como código" - uma imagem docker que já tem pyenv, pycharm e as coisas instalados com o apt que os projetos precisem.
Aí vc trabalha sempre rodando suas ferramentas dentro de um container que já tem algumas dependencias iniciais que seus projetos precisam.

Howto:

Constrói a imagem (ou faz um docker pull)

```
./build.sh
# ou
docker pull tonylampada/buseredev
```

Crie um script pra ativar seu ambdev mais ou menos como esse abaixo
Pode ser que precise de alguma customização, é bom vc entender o que tá rolando, não apenas copiar fe olho fechado:

* Antes de rodar um container, ele cria uma pasta `~/.buserdev` pra armazenar o estado do container entre execuções
* Meus projetos ficam dentro de `~/work` e eu tô injetando essa pasta dentro do container. Seus projetos podem estar em outro lugar
* Estou injetando `~/.ssh` pra poder usar o git. Só faça isso com imagens que vc confia!
* Esses negócio de xhost, X11, DISPLAY é pra gente poder rodar programas com interface gráfica (pycharm) dentro do container
* O meu default é rdar o bash. Vc pode querer rodar o pycharm por default.


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
  tonylampada/buserdev bash
```