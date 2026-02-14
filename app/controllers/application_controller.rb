class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :logged_in?

  private

  def current_user
    # Tenta autenticação por sessão primeiro (web)
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    
    # Se não houver sessão, tenta autenticação JWT (API)
    @current_user ||= authenticate_jwt_user
    
    @current_user
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      respond_to do |format|
        format.html { redirect_to login_path, alert: "Você precisa estar logado para acessar esta página" }
        format.json { render json: { error: 'Não autorizado' }, status: :unauthorized }
      end
    end
  end

  # Autenticação via JWT Token
  def authenticate_jwt_user
    header = request.headers['Authorization']
    return nil unless header.present?

    token = header.split(' ').last
    decoded = JsonWebToken.decode(token)
    
    User.find_by(id: decoded[:user_id]) if decoded
  rescue ActiveRecord::RecordNotFound
    nil
  end
end

