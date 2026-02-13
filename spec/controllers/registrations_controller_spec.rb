require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'logs in the new user automatically' do
        post :create, params: { user: valid_attributes }
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'redirects to root path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it 'sets a success notice' do
        post :create, params: { user: valid_attributes }
        expect(flash[:notice]).to eq('Conta criada com sucesso!')
      end

      it 'downcases the email' do
        post :create, params: { user: valid_attributes.merge(email: 'JOHN@EXAMPLE.COM') }
        expect(User.last.email).to eq('john@example.com')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          email: 'invalid_email',
          password: '123',
          password_confirmation: '456'
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it 'does not log in the user' do
        post :create, params: { user: invalid_attributes }
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'returns unprocessable entity status' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns the user with errors' do
        post :create, params: { user: invalid_attributes }
        expect(assigns(:user).errors).not_to be_empty
      end
    end

    context 'with missing password' do
      let(:invalid_attributes) do
        {
          name: 'John Doe',
          email: 'john@example.com',
          password: '',
          password_confirmation: ''
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it 'renders the new template with errors' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
        expect(assigns(:user).errors[:password]).to be_present
      end
    end

    context 'with duplicate email' do
      let!(:existing_user) { create(:user, email: 'existing@example.com') }
      let(:duplicate_attributes) do
        {
          name: 'Jane Doe',
          email: 'existing@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: { user: duplicate_attributes }
        }.not_to change(User, :count)
      end

      it 'renders the new template with email error' do
        post :create, params: { user: duplicate_attributes }
        expect(response).to render_template(:new)
        expect(assigns(:user).errors[:email]).to include('has already been taken')
      end
    end

    context 'with short password' do
      let(:short_password_attributes) do
        {
          name: 'John Doe',
          email: 'john@example.com',
          password: '12345',
          password_confirmation: '12345'
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: { user: short_password_attributes }
        }.not_to change(User, :count)
      end

      it 'renders the new template with password length error' do
        post :create, params: { user: short_password_attributes }
        expect(response).to render_template(:new)
        expect(assigns(:user).errors[:password]).to be_present
      end
    end

    context 'with mismatched password confirmation' do
      let(:mismatched_attributes) do
        {
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          password_confirmation: 'different123'
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: { user: mismatched_attributes }
        }.not_to change(User, :count)
      end

      it 'renders the new template with confirmation error' do
        post :create, params: { user: mismatched_attributes }
        expect(response).to render_template(:new)
        expect(assigns(:user).errors[:password_confirmation]).to be_present
      end
    end
  end
end
