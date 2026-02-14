class JsonWebToken
  # Chave secreta para assinar tokens JWT
  # Em produção, use uma variável de ambiente: ENV['JWT_SECRET_KEY']
  SECRET_KEY = Rails.application.credentials.secret_key_base

  # Tempo de expiração padrão: 24 horas
  EXPIRATION_TIME = 24.hours.from_now

  # Codifica (cria) um token JWT
  # @param payload [Hash] Dados a serem incluídos no token (ex: { user_id: 1 })
  # @param exp [Time] Tempo de expiração (padrão: 24 horas)
  # @return [String] Token JWT
  def self.encode(payload, exp = EXPIRATION_TIME)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodifica (valida) um token JWT
  # @param token [String] Token JWT a ser decodificado
  # @return [Hash] Payload decodificado
  # @raise [JWT::DecodeError] Se o token for inválido ou expirado
  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT Decode Error: #{e.message}")
    nil
  end
end
