require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:user) { create(:user) }
  let(:url) { '/signup' }
  
  context 'when the request params are valid' do
    before { post url, params: user_params, headers: {} }
    let(:user_params) { { api_v1_user: attributes_for(:user) } }
    
    it 'retorna o http code 200' do
      expect(response).to have_http_status(200)
    end

    it 'retorna os dados em json do usuário cadastrado' do
      expect(json_body[:email]).to eq(user_params[:api_v1_user][:email])
    end

    # it 'returns a new user' do
    #  expect(response.body).to match_schema('User')
    # end

  end

  context 'when the request params are not valid' do
    before { post url, params: user_params, headers: {} }
    let(:user_params) {attributes_for(:user, email: 'invalid_email')}

    it 'returns status code 400' do
        expect(response).to have_http_status(400)
    end

    it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
    end
  end

  context 'when user already exists' do
    before do
      post url, params: user_params, headers: {}
    end
    let(:user_params) { { api_v1_user: create(:user) } }

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end

    it 'returns validation errors' do
      expect(json_body[:errors].first[:title]).to eq('Bad Request')
    end
  end
  
end

