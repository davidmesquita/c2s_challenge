# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts " Iniciando seeds..."

# Criar usuário de exemplo para desenvolvimento
if Rails.env.development?
  demo_user = User.find_or_create_by!(email: 'demo@example.com') do |user|
    user.name = 'Usuário Demo'
    user.password = 'password123'
    user.password_confirmation = 'password123'
  end
  
  puts "   Usuário demo criado:"
  puts "   Email: demo@example.com"
  puts "   Senha: password123"
end

puts " Seeds concluídos!"
