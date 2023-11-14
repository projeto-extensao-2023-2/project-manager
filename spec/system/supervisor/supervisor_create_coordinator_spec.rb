require 'rails_helper'

describe "Supervisor cria um coordenador" do
  it 'com sucesso' do
    user = User.create!(email: 'fabio@gmail.com', password: '123456', role: :supervisor)

    login_as(user)
    visit root_path
    click_on 'Cadastrar coordenador'

    fill_in 'Nome', with: 'Fabio'
    fill_in 'Telefone', with: 'Fabio'
    fill_in 'Campo acadêmico', with: 'Fabio'
    fill_in 'Rua', with: 'Fabio'
    fill_in 'Bairro', with: 'Fabio'
    fill_in 'Complemento', with: 'Fabio'
    fill_in 'CEP', with: 'Fabio'
    fill_in 'Cidade', with: 'Fabio'
    fill_in 'Estado', with: 'Fabio'
    fill_in 'E-mail', with: 'teste@gmail.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Cadastrar'
    click_on 'Visualizar coordenadores'
    click_on 'Visualizar dados'

  end
end