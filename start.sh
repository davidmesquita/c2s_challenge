#!/bin/bash

echo " Iniciando Web Scraping Manager..."
echo ""

# Verifica se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo " Docker não está rodando. Por favor, inicie o Docker Desktop."
    exit 1
fi

echo " Docker está rodando"
echo ""

# Sobe o ambiente
echo " Subindo containers (isso pode levar alguns minutos na primeira vez)..."
docker compose up --build -d

# Aguarda o banco ficar saudável
echo " Aguardando banco de dados..."
timeout=60
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if docker compose exec -T db pg_isready -U postgres > /dev/null 2>&1; then
        echo "Banco de dados pronto!"
        break
    fi
    sleep 2
    elapsed=$((elapsed + 2))
done

# Mostra logs do web
echo ""
echo "Últimos logs do servidor:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker compose logs web --tail 15
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verifica se a aplicação está rodando
if curl -s http://localhost:3000/up > /dev/null 2>&1; then
    echo " Aplicação está rodando!"
else
    echo " Aplicação ainda está inicializando..."
    sleep 3
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Ambiente pronto!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Acesse: http://localhost:3000"
echo ""
echo "Credenciais de acesso:"
echo "   Email: demo@example.com"
echo "   Senha: password123"
echo ""
echo " Comandos úteis:"
echo "   Ver logs:        docker compose logs -f web"
echo "   Parar:           docker compose down"
echo "   Rodar testes:    docker compose exec web bundle exec rspec"
echo ""
