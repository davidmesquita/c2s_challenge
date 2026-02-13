@echo off
echo.
echo ====================================================
echo   Web Scraping Manager - Iniciando Ambiente
echo ====================================================
echo.

REM Verifica se Docker esta rodando
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Docker nao esta rodando.
    echo Por favor, inicie o Docker Desktop.
    pause
    exit /b 1
)

echo [OK] Docker esta rodando
echo.

REM Sobe o ambiente
echo [INFO] Subindo containers...
docker compose up --build -d

REM Aguarda alguns segundos
echo [INFO] Aguardando inicializacao...
timeout /t 10 /nobreak >nul

REM Mostra logs
echo.
echo ====================================================
echo   Logs do Servidor:
echo ====================================================
docker compose logs web --tail 15

REM Status
echo.
echo ====================================================
echo   Ambiente Pronto!
echo ====================================================
echo.
echo [WEB] Acesse: http://localhost:3000
echo.
echo [USER] Credenciais de acesso:
echo        Email: demo@example.com
echo        Senha: password123
echo.
echo [LOGS] Ver logs:     docker compose logs -f web
echo [STOP] Parar:        docker compose down
echo [TEST] Rodar testes: docker compose exec web bundle exec rspec
echo.
pause
