"use strict";

const http = require("node:http");
const { config, validateConfig } = require("./src/config");
const { createStorage } = require("./src/storage");
const { createSecurity } = require("./src/security");
const { createApp } = require("./src/app");

try {
  validateConfig();
  const storage = createStorage(config.dataDir);
  const security = createSecurity({
    password: config.password,
    sessionMs: config.sessionMs,
    cookieSecure: config.cookieSecure,
  });
  const app = createApp({ config, storage, security });

  const server = http.createServer((req, res) => {
    app(req, res).catch((error) => {
      if (error && error.status && error.error) {
        res.writeHead(error.status, { "content-type": "application/json; charset=utf-8" });
        return res.end(JSON.stringify({ erro: error.error }));
      }
      console.error("[server]", error);
      if (!res.headersSent) {
        res.writeHead(500, { "content-type": "application/json; charset=utf-8" });
      }
      res.end(JSON.stringify({ erro: "Erro interno." }));
    });
  });

  server.listen(config.port, config.host, () => {
    console.log(`MarSeguro disponível em http://${config.host}:${config.port}`);
    console.log(`Painel: http://${config.host}:${config.port}/painel`);
    console.log(`IA: ${config.aiKey ? "configurada" : "modo de regras (sem chave de IA)"}`);
    console.log("AVISO: ambiente demonstrativo; não utilizar para decisões reais de segurança no mar.");
  });
} catch (error) {
  console.error(`[configuração] ${error.message}`);
  process.exit(1);
}
