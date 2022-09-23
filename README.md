# buserdev

Estou experimentando com a ideia de ter um "ambdev como código" - uma imagem docker que já vem com as ferramentas necessarias pra trabalhar com:
* backend em python
* frontend com vue (ou qq outra coisa que dependa do node)
* mobile com flutter/android

E o pulo do gato é que a imagem já vem com ferramentas gráficas (tipo o Pycharm e o Sublime) e vc consegue rodá-las como se tivesse local, e o debug funciona. Ou seja vc trabalha sempre rodando suas ferramentas dentro de um container que já tem tudo que vc precisa.
* Vantagem: vc ganha tempo
* Desvantagem: talvez isso te deixe com preguiça de atualizar suas ferramentas de trabalho

Olha esse videozinho mostrando como isso é maneiro :-)

[![Ambdev como código](https://img.youtube.com/vi/oR9YbUcfWqI/0.jpg)](https://www.youtube.com/watch?v=oR9YbUcfWqI)

Howto:

Constrói a imagem (ou faz um docker pull)

```bash
./build.sh
# ou
docker pull tonylampada/buserdev
```

Crie um script pra ativar seu ambdev mais ou menos como o [buserdev.sh](buserdev.sh)
Pode ser que precise de alguma customização, é bom vc entender o que tá rolando, não apenas copiar fe olho fechado:

* Antes de rodar um container, ele cria uma pasta `~/.buserdev` pra armazenar o estado do container entre execuções
* Meus projetos ficam dentro de `~/work` e eu tô injetando essa pasta dentro do container. Seus projetos podem estar em outro lugar
* Estou injetando `~/.ssh` e o ssh-agent pra poder usar o git e o ssh. Só faça isso com imagens que vc confia!
* Esses negócio de xhost, X11, DISPLAY é pra gente poder rodar programas com interface gráfica (pycharm) dentro do container
* O meu default é rodar o bash. Vc pode querer rodar o pycharm por default.

### Exemplos

* Vc já viu como trabalhar com Python e Vue.js [no vídeo acima](https://www.youtube.com/watch?v=oR9YbUcfWqI)
* Veja aqui como vc faz pra [trabalhar com flutter também](README-flutter-howto.md)
