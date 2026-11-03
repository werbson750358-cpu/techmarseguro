# MarSeguro — pacote demonstrativo institucional

## Visão geral

O MarSeguro é um protótipo de sistema de informação para comunicação preventiva de riscos em praias e trechos costeiros. Ele foi pensado para demonstrar o fluxo entre guarda-vidas, avaliação de risco e divulgação pública de alertas. O sistema nunca publica alertas de forma automática; a decisão final sempre pertence a um profissional humano autorizado.

Este pacote é um demonstrador institucional e não substitui monitoramento, previsão oceanográfica, avaliação técnica oficial ou orientações dos órgãos competentes.

## Objetivo da demonstração

- Registrar observações de risco operacionais em campo.
- Gerar um rascunho com apoio de IA ou regras alternativas.
- Revisar e corrigir o texto antes da publicação.
- Publicar alertas preventivos para a população.
- Permitir cancelamento quando a situação for superada ou o prazo vencer.
- Registrar auditoria de ações administrativas.

## Arquitetura

```text
MarSeguro_Demo_Institucional/
├── public/
│   ├── index.html                 # Interface pública para banhistas
│   └── painel.html                # Painel administrativo do guarda-vidas
├── src/
│   ├── ai.js                      # IA opcional e fallback por regras
│   ├── alerts.js                  # Validação, parse e estrutura dos alertas
│   ├── app.js                     # Rotas HTTP, autenticação e API
│   ├── config.js                  # Configuração e variáveis de ambiente
│   ├── security.js                # Sessões, login e proteções
│   └── storage.js                 # Persistência JSON e auditoria
├── data/
│   ├── alertas.json               # Alertas publicados e cancelados
│   └── auditoria.json             # Registro operacional
├── prototipo-independente.html    # Prototipo visual independente preservado
├── .env.example                   # Exemplo de configuração
├── README.md                      # Documento de uso e operação
├── ROTEIRO-DE-DEMONSTRACAO.md      # Roteiro de apresentação
├── server.js                      # Inicialização do servidor
└── public/...
```

## Requisitos

- Node.js 18 ou superior
- Navegador atualizado
- Conexão à internet para carregar o mapa Leaflet/OpenStreetMap
- Chave da API de IA somente para o modo assistivo opcional

## Configuração

Copie as variáveis de ambiente desejadas ou defina-as no terminal antes de iniciar o serviço.

Windows PowerShell:

```powershell
$env:PAINEL_SENHA="uma-senha-forte-com-mais-de-10"
$env:PORT="3000"
node server.js
```

No Windows, também é possível iniciar com duplo clique em `Iniciar-MarSeguro.bat`. O inicializador solicita a senha do painel sem exibi-la, inicia o servidor e abre automaticamente a página pública e o painel no navegador. Se o MarSeguro já estiver rodando na porta configurada, abre as interfaces existentes sem iniciar uma segunda instância. Mantenha a janela do servidor aberta enquanto usar o sistema; pressione `Ctrl+C` nela para encerrar o servidor. A senha não é salva em arquivo.

Se o servidor iniciar em uma porta diferente de `3000`, use os endereços exibidos no terminal. A senha informada no inicializador é a mesma que deve ser digitada no painel.

Linux/macOS:

```bash
export PAINEL_SENHA="uma-senha-forte-com-mais-de-10"
export PORT=3000
node server.js
```

Exemplo completo de configuração em `.env.example`:

```env
HOST=127.0.0.1
PORT=3000
PAINEL_SENHA=troque-por-uma-senha-com-10-caracteres-ou-mais
COOKIE_SECURE=0
AI_API_KEY=
AI_BASE_URL=https://api.anthropic.com
AI_MODEL=claude-haiku-5-5
AI_AUTH=x-api-key
```

Observações:

- Sem `AI_API_KEY`, o sistema usa regras internas para criar um rascunho seguro.
- Não exponha a chave no frontend, no HTML ou no repositório.
- Em produção com HTTPS, use `COOKIE_SECURE=1`.

## Fluxo operacional

1. O profissional acessa o painel em `/painel`.
2. Entra com a senha configurada.
3. Registra uma observação operacional.
4. Solicita geração do rascunho.
5. Revê trecho, risco, explicação e validade.
6. Publica o alerta manualmente.
7. A página pública atualiza automaticamente.
8. O alerta pode ser cancelado manualmente.

## API principal

Rotas expostas pelo backend:

- `GET /api/health` — verificação de saúde do serviço
- `GET /api/alertas` — lista de alertas públicos
- `POST /api/login` — autenticação do painel
- `POST /api/logout` — encerramento da sessão
- `GET /api/painel` — dados do painel e auditoria recente
- `POST /api/rascunho` — geração do rascunho com IA ou regras
- `POST /api/alertas` — publicação de alerta
- `POST /api/alertas/:id/cancelar` — cancelamento de alerta

## Regras de segurança e confiabilidade

- AIA é assistiva; não publica sozinha.
- A decisão final permanece com o profissional humano.
- O texto não pode afirmar que o mar está seguro.
- Os alertas devem mencionar riscos e orientações de prevenção.
- O sistema valida tamanho e estrutura das requisições JSON.
- Sessões são controladas por cookies seguros e expiridade.
- Tentativas repetidas de login são limitadas.
- Cada ação importante é registrada em `data/auditoria.json`.
- Quando informado, o nome do profissional é anotado junto ao evento de auditoria.

## Limites do protótipo

- O mapa é ilustrativo e deve ser tratado como não oficial.
- Não use o mapa para orientar entrada no mar.
- Coordenadas e trechos precisam ser validados por autoridades competentes.
- O armazenamento atual é JSON em arquivo, adequado para demonstração local.
- A sessão fica em memória; não é adequado para produção multiusuário.
- A auditoria registra ações e IP, mas não substitui um sistema de identidade forte e rastreabilidade nominal profissional.
- A IA pode errar e não valida condições oceanográficas de forma oficial.
- Ausência de alerta não significa que o mar está seguro.

## Prototipo independente

O arquivo `prototipo-independente.html` foi preservado e continua sendo um protótipo visual isolado, sem integração automática com o servidor principal. Ele usa simulações locais e não depende dos dados compartilhados do ambiente de demonstração. Ele deve ser tratado como referência visual e não como produto operacional.

## Documento de apresentação

Consulte também `ROTEIRO-DE-DEMONSTRACAO.md` para o fluxo recomendado de apresentação à Prefeitura de Aquiraz e ao Corpo de Bombeiros do Ceará.

## Considerações finais

Este pacote foi organizado para demonstrar uma solução institucional, segura e clara, deixando evidente que:

- o alerta é preventivo;
- a IA é ferramenta de apoio;
- o profissional é responsável pela revisão e publicação;
- o mapa é ilustrativo;
- as decisões reais de segurança devem seguir critérios oficiais e operacionais.

Não é um sistema de monitoramento em produção e não deve ser apresentado como previsão oficial ou substituto de protocolos de salvamento.
