require 'rails_helper'

RSpec.describe 'Pets Test', type: :request do
  let(:user) { create(:user) } 
  let(:pet) { create(:pet) }
  let(:url) { '/pets' }
  
  describe "GET /pets" do
    before do
      create_list(:pet, 5, user_id: user.id)
      get url, params: {}, headers: auth_headers(user)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 pets from database' do
        expect(json_body.count).to eq(5)
    end
  end

  describe "GET /pets/:id" do
    let(:pet) { create(:pet, user_id: user.id) }
    before do
      get "/pets/#{pet.id}", params: {}, headers: auth_headers(user)
    end

    it 'return status code 200' do
        expect(response).to have_http_status(200) 
    end

    it 'return the json data for task' do
        expect(json_body[:name]).to eq(pet.name)
    end
  end
  
  describe 'POST /pets' do
    before do
      post url, params: { pet: pet_params }.to_json , headers: auth_headers(user)
    end

    context 'when the params are valid' do
      let(:pet_params) { attributes_for(:pet) }
    
      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the pet in the database' do
        expect(Pet.find_by(name: pet_params[:name])).not_to be_nil
      end

      it 'returns the json for created pet' do
        expect(json_body[:name]).to eq(pet_params[:name])
      end

      it 'assign the created pet to the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    context 'when the params are invalid' do
      let(:pet_params) { attributes_for(:pet, name: '') }

      it 'return status 200' do
        expect(response).to have_http_status(200)
      end

      it 'does not save the pet in the database' do
        expect(Pet.find_by(name: pet_params[:name])).to be_nil
      end

      it 'returns the json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /pets/:id' do
    let!(:pet) { create(:pet, user_id: user.id) }

    before do
      put "/pets/#{pet.id}", params: pet_params.to_json, headers: auth_headers(user)
    end

    context 'when the param are valid' do
      let(:pet_params) { { name: 'Brad Pit' } }

      it 'return status code 202' do
        expect(response).to have_http_status(202)
      end

      it 'returns the json for updated pet' do
        expect(json_body[:name]).to eq(pet_params[:name])
      end

      it 'updates the pet in the database' do
        expect( Pet.find_by(name: pet_params[:name])).not_to be_nil
      end
    end

    context 'when the params are invalid' do
      let(:pet_params) { { name: '' } }

      it 'return status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'return the json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end

      it 'does not update the pet in the database' do
        expect(Pet.find_by(name: pet_params[:name])).to be_nil
      end
    end
  end

  describe 'DELETE /pets/:id' do
    let!(:pet) { create(:pet, user_id: user.id) }

    before  do
      delete "/pets/#{pet.id}", params: {}, headers: auth_headers(user)
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the task from the database' do
      expect { Pet.find(pet.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
end