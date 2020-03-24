require 'rails_helper'

RSpec.describe 'Dogwalkings Test', type: :request do
  let!(:user) { create(:user) } 
  let(:dogwalking) { create(:dogwalking) }
  let(:url) { '/dogwalkings' }
  
  describe "GET /dogwalkings" do
    before do
      create_list(:dogwalking, 5, user_id: user.id)
      get url, params: {}, headers: auth_headers(user)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 dogwalkings from database' do
      expect(json_body.count).to eq(5)
    end
  end

  describe "GET /dogwalkings?next=true" do
    before do
      create_list(:dogwalking, 5, schedule_date: Time.current + 2.day, user_id: user.id)
      create_list(:dogwalking, 5, user_id: user.id)
      get "#{url}/?next=true", params: {}, headers: auth_headers(user)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 dogwalkings from database' do
      expect(Dogwalking.since_today.count).to eq(5)
    end
  end
  
  describe "GET /dogwalkings/:id" do
    let(:dogwalking) { create(:dogwalking, user_id: user.id) }
    before do
      get "/dogwalkings/#{dogwalking.id}", params: {}, headers: auth_headers(user)
    end

    it 'return status code 200' do
      expect(response).to have_http_status(200) 
    end

    it 'return the json data for dogwalking' do
      expect(json_body[:dogwalking][:id]).to eq(dogwalking[:id])
    end
  end

  describe 'POST /dogwalkings' do
    before do
      post url, params: dogwalking_params.to_json , headers: auth_headers(user)
    end

    context 'when the params are valid' do
      let(:dogwalking_params) { attributes_for(:dogwalking) }
    
      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the pet in the database' do
        expect(Dogwalking.find_by(schedule_date: dogwalking_params[:schedule_date])).not_to be_nil
      end

      it 'returns the json for created pet' do
        expect(json_body[:id]).to eq(dogwalking_params[:id])
      end

      it 'assign the created dogwalking to the current user' do
        expect(json_body[:dogwalking][:user_id]).to eq(user.id)
      end
    end

    context 'when the params are invalid' do
      let(:dogwalking_params) { attributes_for(:dogwalking, duration: '') }

      it 'return status 400' do
        expect(response).to have_http_status(400)
      end

      it 'does not save the pet in the database' do
        expect(Dogwalking.find_by(duration: dogwalking_params[:duration])).to be_nil
      end

      it 'returns the json error for name' do
        expect(json_body[:errors]).to have_key(:duration)
      end
    end
  end

  describe 'PATCH /dogwalkings/:id/start_walk' do
    let!(:dogwalking) { create(:dogwalking, user_id: user.id) }

    before do
      patch "/dogwalkings/#{dogwalking.id}/start_walk", params: dogwalking_params.to_json, headers: auth_headers(user)
    end

    context 'when the param are valid' do
      let(:dogwalking_params) { {  } }

      it 'return status code 202' do
        expect(response).to have_http_status(202)
      end

      it 'updates the pet in the database' do
        expect( Dogwalking.find_by(schedule_date: dogwalking.schedule_date)).not_to be_nil
      end
    end
  end

  describe 'PATCH /dogwalkings/:id/finish_walk' do
    let!(:dogwalking) { create(:dogwalking, user_id: user.id) }

    before do
      patch "/dogwalkings/#{dogwalking.id}/finish_walk", params: dogwalking_params.to_json, headers: auth_headers(user)
    end

    context 'when the param are valid' do
      let(:dogwalking_params) { {  } }

      it 'return status code 202' do
        expect(response).to have_http_status(202)
      end

      it 'updates the pet in the database' do
        expect( Dogwalking.find_by(schedule_date: dogwalking.schedule_date)).not_to be_nil
      end
    end
  end
  
end