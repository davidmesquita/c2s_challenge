require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:password).is_at_least(6) }
    
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
    it { should_not allow_value('user@').for(:email) }
  end

  describe 'secure password' do
    it 'has secure password' do
      user = build(:user, password: 'password123')
      expect(user).to have_attributes(password_digest: be_present)
    end

    it 'authenticates with correct password' do
      user = create(:user, password: 'password123')
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with wrong password' do
      user = create(:user, password: 'password123')
      expect(user.authenticate('wrong_password')).to be_falsey
    end
  end

  describe 'email normalization' do
    it 'downcases email before save' do
      user = create(:user, email: 'USER@EXAMPLE.COM')
      expect(user.email).to eq('user@example.com')
    end

    it 'downcases email on update' do
      user = create(:user, email: 'user@example.com')
      user.update(email: 'UPDATED@EXAMPLE.COM')
      expect(user.email).to eq('updated@example.com')
    end
  end

  describe 'password confirmation' do
    it 'is valid with matching password confirmation' do
      user = build(:user, password: 'password123', password_confirmation: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid with non-matching password confirmation' do
      user = build(:user, password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
    end
  end

  describe 'uniqueness' do
    it 'does not allow duplicate emails' do
      create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'test@example.com')
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end

    it 'does not allow duplicate emails (case-insensitive due to downcase)' do
      create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'TEST@EXAMPLE.COM')
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end
  end
end
