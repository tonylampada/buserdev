# buserdev

Estou experimentando com a ideia de ter um "ambdev como código" - uma imagem docker que já tem:
* pyenv, nvm, fvm, pycharm, sublime, e até a trolha do android-studio
* com uns plugins bacanas do sublime e do pycharm
* e com algumas dependências básicas que os projetos precisam

E aí vc trabalha sempre rodando suas ferramentas dentro de um container que já tem tudo que vc precisa
* Vantagem: vc ganha tempo
* Desvantagem: talvez isso te deixe com preguiça de atualizar suas ferramentas de trabalho

Howto:

Constrói a imagem (ou faz um docker pull)

```
./build.sh
# ou
docker pull tonylampada/buseredev
```

Crie um script pra ativar seu ambdev mais ou menos como o [buserdev.sh](buserdev.sh)
Pode ser que precise de alguma customização, é bom vc entender o que tá rolando, não apenas copiar fe olho fechado:

* Antes de rodar um container, ele cria uma pasta `~/.buserdev` pra armazenar o estado do container entre execuções
* Meus projetos ficam dentro de `~/work` e eu tô injetando essa pasta dentro do container. Seus projetos podem estar em outro lugar
* Estou injetando `~/.ssh` e o ssh-agent pra poder usar o git e o ssh. Só faça isso com imagens que vc confia!
* Esses negócio de xhost, X11, DISPLAY é pra gente poder rodar programas com interface gráfica (pycharm) dentro do container
* O meu default é rodar o bash. Vc pode querer rodar o pycharm por default.
