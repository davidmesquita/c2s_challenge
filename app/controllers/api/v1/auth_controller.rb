class Api::V1::AuthController < ApplicationController
  skip_before_action :require_login, only: [:login, :signup]
  skip_before_action :verify_authenticity_token

  # POST /api/v1/auth/login
  # Autenticação via JWT
  # Params: { email: "user@example.com", password: "password123" }
  # Response: { token: "jwt_token", exp: "2026-02-14T12:00:00Z", user: { id: 1, email: "user@example.com" } }
  def login
    user = User.find_by(email: params[:email]&.downcase)
    
    if user&.authenticate(params[:password])
      exp_time = 24.hours.from_now
      token = JsonWebToken.encode({ user_id: user.id }, exp_time)
      
      render json: {
        token: token,
        exp: exp_time.iso8601,
        expires_in: 86400, # 24 horas em segundos
        user: {
          id: user.id,
          email: user.email,
          created_at: user.created_at
        }
      }, status: :ok
    else
      render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
    end
  end

  # POST /api/v1/auth/signup
  # Registro de novo usuário com JWT
  # Params: { email: "user@example.com", password: "password123", password_confirmation: "password123" }
  def signup
    user = User.new(user_params)
    
    if user.save
      exp_time = 24.hours.from_now
      token = JsonWebToken.encode({ user_id: user.id }, exp_time)
      
      render json: {
        token: token,
        exp: exp_time.iso8601,
        expires_in: 86400,
        user: {
          id: user.id,
          email: user.email,
          created_at: user.created_at
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/auth/validate
  # Valida um token JWT
  # Header: Authorization: Bearer <token>
  def validate
    render json: {
      valid: true,
      user: {
        id: @current_user.id,
        email: @current_user.email
      }
    }, status: :ok
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
