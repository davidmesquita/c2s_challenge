.PHONY: help start stop restart logs test console clean db-reset

help: ## Mostra esta mensagem de ajuda
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Web Scraping Manager - Comandos Disponíveis"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

start: ## Inicia todo o ambiente (build + database + seeds)
	@echo " Iniciando ambiente..."
	docker compose up --build -d
	@echo " Aguardando inicialização..."
	@sleep 5
	@docker compose logs web --tail 10
	@echo ""
	@echo " Ambiente rodando em http://localhost:3000"
	@echo " Email: demo@example.com | Senha: password123"

stop: ## Para todos os containers
	@echo " Parando containers..."
	docker compose down

restart: stop start ## Reinicia todo o ambiente

logs: ## Mostra logs em tempo real
	docker compose logs -f web

test: ## Executa todos os testes
	@echo " Executando testes..."
	docker compose exec web bundle exec rspec

test-verbose: ## Executa testes com saída detalhada
	docker compose exec web bundle exec rspec --format documentation

console: ## Abre console Rails
	docker compose exec web bundle exec rails console

bash: ## Abre shell bash no container
	docker compose exec web bash

db-reset: ## Reseta o banco de dados
	@echo "  Resetando banco de dados..."
	docker compose exec web bundle exec rails db:drop db:create db:migrate db:seed
	@echo " Banco resetado com sucesso!"

db-migrate: ## Executa migrations pendentes
	docker compose exec web bundle exec rails db:migrate

clean: ## Remove containers, volumes e imagens
	@echo " Limpando ambiente..."
	docker compose down -v --rmi local
	@echo " Limpeza concluída!"

status: ## Mostra status dos containers
	docker compose ps

build: ## Faz rebuild das imagens
	docker compose build --no-cache
