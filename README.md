# README

## Rodando com Docker

Suba app + banco PostgreSQL:

```bash
docker compose up --build
```

A aplicação ficará disponível em `http://localhost:3000`.

Comandos úteis:

```bash
# Subir em background
docker compose up -d --build

# Ver logs
docker compose logs -f web

# Parar serviços
docker compose down
```
