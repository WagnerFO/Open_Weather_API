# Open Weather Flutter

Aplicativo Flutter de clima usando a API da OpenWeather. O app permite buscar cidades, ver previsão atual, alertas meteorológicos, histórico das últimas cidades buscadas e um mapa interativo com camadas climáticas.

## Funcionalidades

- Clima atual por localização ou cidade buscada.
- Busca de cidades pela API de geocoding da OpenWeather.
- Histórico das 5 últimas cidades buscadas.
- Tela de alertas meteorológicos.
- Mapa interativo com camadas de chuva, nuvens, temperatura e vento.
- Menu lateral de navegação.
- Interface em português do Brasil.

## Tecnologias

- Flutter
- Dart
- Riverpod
- Dio
- Geolocator
- Flutter Dotenv
- Flutter Map
- OpenWeather API

## Pré-requisitos

Antes de rodar o projeto, instale:

- Flutter SDK configurado.
- Dart compatível com o projeto.
- Android Studio ou VS Code com extensões Flutter/Dart.
- Android SDK.
- Um emulador Android ou um dispositivo físico.
- Uma chave da OpenWeather.

Confira se o Flutter está pronto:

```bash
flutter doctor
```

Resolva os problemas indicados pelo `flutter doctor` antes de continuar.

## Configurando a OpenWeather

1. Crie uma conta em:

```text
https://openweathermap.org/
```

2. Gere uma API key no painel da OpenWeather.

3. Na raiz do projeto, crie um arquivo chamado `.env`.

4. Dentro do `.env`, adicione:

```env
OPENWEATHER_API_KEY=SUA_CHAVE_AQUI
```

Exemplo:

```env
OPENWEATHER_API_KEY=abc123minhachave
```

Importante: não use aspas e não deixe espaços antes/depois da chave.

## Instalando o projeto

Clone o repositório:

```bash
git clone https://github.com/WagnerFO/Open_Weather_API.git
```

Entre na pasta do projeto:

```bash
cd Open_Weather_API
```

Instale as dependências:

```bash
flutter pub get
```

## Rodando no Android Studio

1. Abra o projeto no Android Studio.
2. Vá em **Device Manager**.
3. Crie ou inicie um emulador Android.
4. Selecione o emulador no topo do Android Studio.
5. Clique em **Run**.

Também é possível rodar pelo terminal:

```bash
flutter devices
flutter run
```

Para escolher um dispositivo específico:

```bash
flutter run -d emulator-5554
```

## Rodando no VS Code

1. Abra a pasta do projeto no VS Code.
2. Inicie um emulador Android.
3. Selecione o dispositivo no canto inferior direito.
4. Pressione `F5` ou rode:

```bash
flutter run
```

## Permissão de localização

O app usa localização para buscar o clima atual quando nenhuma cidade foi selecionada.

No emulador ou celular, aceite a permissão de localização quando o app pedir.

Se a permissão for negada, o app pode mostrar erro de localização. Nesse caso:

- Libere a permissão nas configurações do app.
- Ou busque uma cidade manualmente na tela inicial.

## Mapa climático

A tela de mapa usa:

- OpenStreetMap como mapa base.
- OpenWeather Tile Layers como camada climática.

Camadas disponíveis:

- Chuva: `precipitation_new`
- Nuvens: `clouds_new`
- Temperatura: `temp_new`
- Vento: `wind_new`

A URL usada segue este formato:

```text
https://tile.openweathermap.org/map/{layer}/{z}/{x}/{y}.png?appid=SUA_CHAVE
```

## Histórico

Quando uma cidade é selecionada na busca da Home, ela é salva no histórico.

Regras atuais:

- Guarda apenas as 5 últimas cidades.
- Não duplica a mesma cidade.
- Ao selecionar uma cidade do histórico, a Home carrega essa cidade novamente.
- O histórico fica em memória; ao fechar/reiniciar o app, ele começa vazio.

## Testes e análise

Rode a análise estática:

```bash
flutter analyze
```

Rode os testes:

```bash
flutter test
```

## Problemas comuns

### INSTALL_FAILED_INSUFFICIENT_STORAGE

O emulador está sem espaço.

Soluções:

```bash
adb uninstall com.example.flutter_application
```

Ou, no Android Studio:

1. Abra **Device Manager**.
2. Clique nos três pontos do emulador.
3. Selecione **Wipe Data**.
4. Inicie o emulador novamente.

### No emulators available

Crie um emulador pelo Android Studio:

1. **Tools > Device Manager**
2. **Create Device**
3. Escolha um Pixel.
4. Baixe uma imagem Android x86_64 com Google APIs ou Google Play.
5. Clique em **Finish**.

### Erros de API ou clima não carregando

Verifique:

- O arquivo `.env` existe na raiz.
- A variável se chama exatamente `OPENWEATHER_API_KEY`.
- A chave da OpenWeather está ativa.
- O dispositivo/emulador tem internet.

### Logs do flutter_map sobre cache

Mensagens como esta são informativas:

```text
Using fallback freshness age to cache...
```

Isso indica apenas que o servidor de tiles não enviou informações completas de cache. O mapa continua funcionando.

## Estrutura principal

```text
lib/
  core/
    constants/
    navigation/
    helpers/
  data/
    models/
    repositories/
  domain/
    providers/
  presentation/
    screens/
    widgets/
```

## Observações

O arquivo `.env` contém informação sensível e não deve ser enviado com uma chave real para repositórios públicos.

Se outro usuário clonar o projeto, ele precisa criar o próprio `.env` com a própria chave da OpenWeather.
