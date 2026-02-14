# Web Scraping Manager 🚗

Sistema de gerenciamento de tarefas de web scraping de veículos desenvolvido com Ruby on Rails 7.1.6.

## 🚀 Início Rápido

### Opção 1: Usando o script de inicialização (Recomendado)

**Windows:**
```cmd
start.bat
```

**Linux/Mac:**
```bash
./start.sh
```

### Opção 2: Usando Makefile (Linux/Mac)

```bash
make start
```

### Opção 3: Comando direto do Docker Compose

```bash
docker compose up --build
```

**Pronto!** A aplicação estará disponível em `http://localhost:3000`

O ambiente já vem configurado automaticamente com:
- ✅ PostgreSQL rodando e saudável
- ✅ Banco de dados criado e migrado
- ✅ Seeds executados (usuário demo)
- ✅ Servidor Rails iniciado

### 👤 Credenciais de Acesso (Ambiente de Desenvolvimento)

```
Email: demo@example.com
Senha: password123
```

## 📋 Comandos Úteis

### Usando Makefile (Linux/Mac)
```bash
make help          # Ver todos os comandos disponíveis
make start         # Iniciar ambiente
make stop          # Parar ambiente
make restart       # Reiniciar ambiente
make logs          # Ver logs em tempo real
make test          # Rodar testes
make console       # Abrir console Rails
make bash          # Abrir shell bash
make db-reset      # Resetar banco de dados
```

### Usando Docker Compose (Todas as plataformas)
```bash
# Subir em background
docker compose up -d --build

# Ver logs em tempo real
docker compose logs -f web

# Parar serviços
docker compose down

# Rodar testes
docker compose exec web bundle exec rspec

# Acessar console Rails
docker compose exec web bundle exec rails console

# Executar migrations
docker compose exec web bundle exec rails db:migrate

# Resetar banco de dados
docker compose exec web bundle exec rails db:reset
```

## 🏗️ Stack Tecnológica

- **Ruby**: 3.0.6
- **Rails**: 7.1.6
- **Banco de Dados**: PostgreSQL 16
- **Autenticação**: BCrypt
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Testes**: RSpec, FactoryBot, Capybara
- **Containerização**: Docker + Docker Compose

## 🧪 Executando Testes

```bash
# Todos os testes
docker compose exec web bundle exec rspec

# Testes com cobertura detalhada
docker compose exec web bundle exec rspec --format documentation

# Teste específico
docker compose exec web bundle exec rspec spec/models/user_spec.rb
```

## 📁 Estrutura do Projeto

```
app/
├── controllers/     # Controladores (Sessions, Registrations, Home)
├── models/          # Modelos (User)
├── views/           # Views (Login, Cadastro, Dashboard)
└── assets/          # CSS, JavaScript

spec/               # Testes RSpec
config/             # Configurações Rails
db/                 # Migrations e Seeds
```

## 🔒 Segurança

- Senhas encriptadas com BCrypt
- Proteção CSRF habilitada
- Strong parameters nos controllers
- Validações no modelo

## 📝 Licença

Este projeto está licenciado sob a MIT License.
