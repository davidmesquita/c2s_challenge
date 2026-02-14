# API de Autenticação JWT

## 📝 Visão Geral

Microsserviço de autenticação utilizando JWT (JSON Web Token) com tempo de expiração.

## 🔐 Endpoints Disponíveis

### 1. Login (POST `/api/v1/auth/login`)

Autentica um usuário e retorna um token JWT válido por 24 horas.

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@example.com",
    "password": "password123"
  }'
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "exp": "2026-02-14T12:00:00Z",
  "expires_in": 86400,
  "user": {
    "id": 1,
    "email": "demo@example.com",
    "created_at": "2026-02-13T12:00:00.000Z"
  }
}
```

**Response (401 Unauthorized):**
```json
{
  "error": "Email ou senha inválidos"
}
```

---

### 2. Registro (POST `/api/v1/auth/signup`)

Cria um novo usuário e retorna um token JWT.

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "novo@example.com",
    "password": "senha123456",
    "password_confirmation": "senha123456"
  }'
```

**Response (201 Created):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "exp": "2026-02-14T12:00:00Z",
  "expires_in": 86400,
  "user": {
    "id": 2,
    "email": "novo@example.com",
    "created_at": "2026-02-13T12:00:00.000Z"
  }
}
```

**Response (422 Unprocessable Entity):**
```json
{
  "errors": [
    "Email já está em uso",
    "Senha é muito curta (mínimo: 6 caracteres)"
  ]
}
```

---

### 3. Validar Token (GET `/api/v1/auth/validate`)

Valida um token JWT e retorna informações do usuário.

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/auth/validate \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..."
```

**Response (200 OK):**
```json
{
  "valid": true,
  "user": {
    "id": 1,
    "email": "demo@example.com"
  }
}
```

**Response (401 Unauthorized):**
```json
{
  "error": "Não autorizado"
}
```

---

## 🔑 Utilizando o Token JWT

Após obter o token através do login ou signup, inclua-o no header `Authorization` de todas as requisições protegidas:

```bash
curl -X GET http://localhost:3000/api/v1/algum_recurso \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

## ⏱️ Tempo de Expiração

- **Duração do Token:** 24 horas (86400 segundos)
- **Campo `exp`:** Timestamp ISO 8601 indicando quando o token expira
- **Campo `expires_in`:** Segundos até a expiração

## 🛡️ Segurança

- Tokens são assinados com `secret_key_base` do Rails
- Tokens expirados são automaticamente rejeitados
- Senhas são criptografadas com BCrypt
- Validação de email único e senha mínima de 6 caracteres

## 🧪 Testando a API

### Instalar dependência JWT:
```bash
docker compose exec web bundle install
docker compose restart web
```

### Testar Login:
```powershell
$body = @{
    email = "demo@example.com"
    password = "password123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:3000/api/v1/auth/login" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body

$response | ConvertTo-Json
```

### Salvar Token e Fazer Requisição Autenticada:
```powershell
$token = $response.token

$headers = @{
    "Authorization" = "Bearer $token"
}

Invoke-RestMethod -Uri "http://localhost:3000/api/v1/auth/validate" `
    -Method Get `
    -Headers $headers | ConvertTo-Json
```

## 📊 Estrutura do Projeto

```
app/
├── controllers/
│   ├── application_controller.rb      # Suporta autenticação JWT + Session
│   └── api/
│       └── v1/
│           └── auth_controller.rb     # Endpoints JWT
├── services/
│   └── json_web_token.rb              # Encode/Decode JWT
└── models/
    └── user.rb                        # Modelo de usuário
```

## 🔄 Autenticação Híbrida

A aplicação suporta **dois tipos de autenticação**:

1. **Web (Session-based):** Para navegadores, usando cookies de sessão
2. **API (JWT-based):** Para aplicações cliente, usando tokens JWT

O `ApplicationController` detecta automaticamente qual método usar baseado na presença do header `Authorization`.

## 📝 Requisitos Atendidos

✅ Utiliza JWT (JSON Web Token) para autenticação  
✅ Retorna token com tempo de expiração (24 horas)  
✅ Token inclui informações do usuário  
✅ Validação de token implementada  
✅ Endpoints de login e signup  
✅ Tratamento de erros apropriado  

---

**Desenvolvido como parte do C2S Challenge** 🚗
