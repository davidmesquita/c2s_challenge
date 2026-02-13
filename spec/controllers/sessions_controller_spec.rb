require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

      it 'logs in the user' do
        post :create, params: { email: user.email, password: 'password123' }
        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to root path' do
        post :create, params: { email: user.email, password: 'password123' }
        expect(response).to redirect_to(root_path)
      end

      it 'sets a success notice' do
        post :create, params: { email: user.email, password: 'password123' }
        expect(flash[:notice]).to eq('Login realizado com sucesso!')
      end

      it 'is case-insensitive for email' do
        post :create, params: { email: user.email.upcase, password: 'password123' }
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

      it 'does not log in with wrong password' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(session[:user_id]).to be_nil
      end

      it 'does not log in with non-existent email' do
        post :create, params: { email: 'nonexistent@example.com', password: 'password123' }
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(response).to render_template(:new)
      end

      it 'sets an alert message' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(flash[:alert]).to eq('Email ou senha inválidos')
      end

      it 'returns unprocessable entity status' do
        post :create, params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    it 'logs out the user' do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to login path' do
      delete :destroy
      expect(response).to redirect_to(login_path)
    end

    it 'sets a success notice' do
      delete :destroy
      expect(flash[:notice]).to eq('Logout realizado com sucesso!')
    end
  end
end
