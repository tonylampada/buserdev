# Exemplo flutter

Dentro dessa imagem já tem ferramentas necessárias pra você desenvolver em flutter:

* fvm - pra vc poder ter diferentes versoes de flutter no "computador"
* sdkmanager - pra vc poder baixar as montanhas infinitas de libs do google necessárias pra mexer com qq coisa do android
* avdmanager - pra emular o android
* ~~android-studio~~ - a melhor parte, sem depender de **mais essa** coisa enorme aí

Os comandos abaixo é pra te guiar pra subir um projeto flutter (não é pra selecionar tudo e dar ctrl+v de uma vez, vai fazendo aos poucos pra vc ir entendendo o que tá rolando)


```bash
cd ~/work
git clone https://github.com/devonfw-forge/devonfw4flutter-mts-app.git  # um projeto flutter qualquer que eu achei no github
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