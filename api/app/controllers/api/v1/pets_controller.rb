class Api::V1::PetsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :instanciar_pet, except: %i[index create]

  def index
    pets = current_api_v1_user.pets
    render json: pets, status: :ok
  end

  def show
    if @pet
      render json: @pet, status: :ok
    else
      render json: {
        errors: ['Not found.']
      }, status: :not_found
    end
  end

  def create
    pet = current_api_v1_user.pets.new pet_params

    if pet.save
      render json: pet, status: :created
    else
      render json: {
        errors: pet.errors
      }, stauts: :bad_request
    end
  end

  def update
    if @pet.update pet_params
      render json: @pet, status: 202
    else
      render json: {
        errors: @pet.errors
      }, status: :bad_request
    end
  end

  def destroy
    @pet.destroy
    head :no_content
  end
  
  private

    def instanciar_pet
      @pet = current_api_v1_user.pets.find params[:id]
    end

    def pet_params
      params.require(:pet).permit(:name, :age, :gender, :size, :breed)
    end
end
