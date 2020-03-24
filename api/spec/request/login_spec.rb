require 'rails_helper'

RSpec.describe 'Authentication Test', type: :request do
  let(:user) { create(:user) }
  let(:url) { '/login' }
  let(:headers) do
    {
        'Content-Type' => 'application/json'
    }
  end
  
  describe 'POST /login' do
    before do
      post url, params: user_params.to_json, headers: headers
    end
    let(:user_params) { { api_v1_user: { email: user.email, password: user.password } } }
    context 'when params are correct' do

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
  
      it 'returns JTW token in authorization header' do
        expect(response.headers['Authorization']).to be_present
      end
    end

    context 'when the credentials are incorrect' do
      let(:user_params) { { api_v1_user: { email: user.email, password: 'senha_invalida' } } }
  
      it 'returns status code 401' do
          expect(response).to have_http_status(401)
      end
  
      it 'returns the json data for the errors' do
          expect(json_body).to have_key(:error)
      end
    end
    
  
    context 'when login params are incorrect' do
      before { post url }
      
      it 'returns unathorized status' do
        expect(response.status).to eq 401
      end
    end
  end
end

RSpec.describe 'DELETE /logout', type: :request do
  let(:url) { '/logout' }

  it 'returns 204, no content' do
    delete url
    expect(response).to have_http_status(204)
  end
end