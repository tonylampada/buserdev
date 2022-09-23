# Exemplo flutter

Dentro dessa imagem já tem ferramentas necessárias pra você desenvolver em flutter:

* fvm - pra vc poder ter diferentes versoes de flutter no "computador"
* sdkmanager - pra vc poder baixar as montanhas infinitas de libs do google necessárias pra mexer com qq coisa do android
* avdmanager - pra emular o android
* ~~android-studio~~ - a melhor parte, sem depender de **mais essa** coisa enorme aí

Os comandos abaixo é pra te guiar pra subir um projeto flutter (não é pra selecionar tudo e dar ctrl+v de uma vez, vai fazendo aos poucos pra vc ir entendendo o que tá rolando)


```bash
cd ~/work
git clone https://github.com/tonylampada/devonfw4flutter-mts-app.git  # um projeto flutter qualquer que eu achei no github
cd devonfw4flutter-mts-app
fvm install 1.17.0 # no repo nao fala, mas essa versao velha do flutter vai funcionar com esse projeto aih
fvm use 1.17.0 # isso aih vai criar a pasta .fvm no projeto (se o codigo fosse seu vc deveria botar isso no .gitignore)
flutter --version # ve se ta certa a versao
which flutter # Importante saber ne. Olha o PATH e entende aih de onde ta vindo o executavel. 
flutter doctor # vai dar varios paus. pra começo de conversa nao tem android sdk nenhum

sdkmanager --list # so pra vc ver a "listinha". (o google perdeu a mao nisso aih, mas isso nao vem ao caso)
yes | sdkmanager "platforms;android-33" "system-images;android-33;google_apis;x86_64" "build-tools;33.0.0" # instala umas paradinhas aih

flutter doctor # já melhorou né. Agora ele tá chorando por causa de umas licenças...
yes | flutter doctor --android-licenses # feita a leitura
flutter doctor # "no devices". Beleza bora criar um device...

avdmanager create avd --name android33 --package "system-images;android-33;google_apis;x86_64"
emulator -avd android33
```

E funciona \o/

<img src="https://user-images.githubusercontent.com/218821/191873180-b6d5f1a9-5784-44c0-b96e-200f05d44f56.png" width="300">

```bash
# continuando
flutter doctor  # agora ele ta chorando que nao tem android-studio, mas isso eh feature e nao bug

flutter devices  # agora ele ve o nosso device novinho

flutter pub get  # isso aih eh tipo o "npm install" do dart (sinceramente nem sei onde ele baixa as coisas)
flutter run  # hora da verdade (relaxa isso demora)
```

Eita deu pau.

![image](https://user-images.githubusercontent.com/218821/191874709-82f8a264-27a5-46a8-8680-e3381d70488e.png)

insuficcient storage. ops.

Mas aí vc edita esse arquivo `config.ini` do emulador, reinicia ele e tenta de novo
![image](https://user-images.githubusercontent.com/218821/191874895-43df9c2d-e178-4187-ada5-f29fb39510d5.png)

(Reparou eu tirando onda aih com meu sublime tunado intra-container né)

Aih vc manda o `flutter run` que ele vai.

![image](https://user-images.githubusercontent.com/218821/191875061-8d7ebd53-2dc9-4d48-ba84-98f35c80a04e.png)

Maravilha. Flutter rodando na linha de comando. Sem Android Studio. 
E pra debugar?

# Debugando flutter com o vscode

Tem um pulo do gato bacana que é o usar o vscode com o "plugin de teletransporte" dele. Mais fácil explicar isso com um vídeo.

[![Debugando flutter com vscode](https://img.youtube.com/vi/xMLyS0B4cK0/0.jpg)](https://www.youtube.com/watch?v=xMLyS0B4cK0)
