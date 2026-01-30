# 🎮 Como Rodar o Flappy Pix Localmente

Este guia explica como rodar o jogo localmente no seu computador, evitando os erros antigos de build (Gulp/Phaser).

## 🚀 Guia Rápido

Como o sistema de build original deste projeto (Gulp) é muito antigo e incompatível com versões modernas do Node.js, nós ajustamos o projeto para rodar diretamente sem necessidade de compilação.

### 1. Pré-requisitos
Certifique-se de ter o **Node.js** instalado no seu computador.

### 2. Iniciar o Servidor
Abra o terminal na pasta do projeto e rode o seguinte comando:

```bash
npx http-server -p 8080
```

*Se perguntar para instalar o `http-server`, digite `y` (yes) e dê Enter.*

### 3. Acessar o Jogo
Abra o seu navegador e acesse:

👉 **http://localhost:8080**

---

## 🔧 Por que não usar `npm start`?
O comando `npm start` antigo tenta rodar scripts do Gulp que quebram em versões novas do Windows e Node.js. 

Nós modificamos o `index.html` para:
1. Carregar o **Phaser** diretamente da pasta `bower_components`.
2. Carregar o **index.js** original (código fonte) em vez do `index.min.js` (que estava desatualizado/quebrado).

Dessa forma, você edita o `index.js` ou `index.html` e vê as alterações **imediatamente** ao recarregar a página, sem precisar "compilar" nada!

## ⚠️ Solução de Problemas

- **Erro "Address already in use"**: Se a porta 8080 estiver ocupada, tente outra porta:
  ```bash
  npx http-server -p 8081
  ```
- **Cache**: Se você fez uma alteração e ela não apareceu, limpe o cache do navegador ou abra em uma aba anônima.
