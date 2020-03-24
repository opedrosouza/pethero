class Api::V1::DogwalkingsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :instanciar_dogwalking, except: %i[index create]

  def index
    if params[:nexts]
      dogwalkings = current_api_v1_user.dogwalkings.since_today
    else
      dogwalkings = current_api_v1_user.dogwalkings
    end

    render json: dogwalkings, status: :ok
  end

  def show
    if @dogwalking
      real_duration = (@dogwalking.finish_hour - @dogwalking.init_hour) / 60 # tempo em minutos
      render json: {
        dogwalking: {
          id: @dogwalking.id,
          status: @dogwalking.status,
          walking_duration: real_duration
        }
      }, status: :ok
    else
      render json: {
        errors: ['Not found.']
      }, status: :not_found
    end
  end

  def create
    dogwalking = current_api_v1_user.dogwalkings.new dogwalking_params
    puts "======================================"
    ap dogwalking_params
    #pets = current_api_v1_user.pets

    dogwalking.status = 1
    dogwalking.schedule_date = Time.parse(dogwalking_params[:schedule_date])
    dogwalking.init_hour = Time.parse(dogwalking_params[:init_hour])

    if dogwalking_params[:duration] == 1
      dogwalking.finish_hour = Time.parse(dogwalking_params[:init_hour]) + 30.minute
    else
      dogwalking.finish_hour = Time.parse(dogwalking_params[:init_hour]) + 60.minute
    end

    puts dogwalking.pets.count
    dogwalking.price = price_calculator dogwalking.pet_ids.count, dogwalking.duration

    if dogwalking.save
      render json: {
        dogwalking: dogwalking,
        pets: dogwalking.pets.collect{|x|["Name: #{x.name}","Breed: #{x.breed}"]}
        }, status: :created
    else
      render json: {
        errors: dogwalking.errors
      }, status: :bad_request
    end
  end

  def start_walk
    if @dogwalking.init_hour <= Time.current
      @dogwalking.status = 2
      if @dogwalking.save
        render json: {
          dogwalking: @dogwalking,
          message: 'Starting the walking'
        }, status: 202
      end
    else
      render json: {
        errors: ['You has started this walking before.']
      }, status: :bad_request
    end
  end

  def finish_walk
    @dogwalking.status = 3
    @dogwalking.finish_hour = Time.current
    if @dogwalking.save
      render json: {
        dogwalking: @dogwalking
      }, status: 202
    end
  end

  private

    def instanciar_dogwalking
      @dogwalking = current_api_v1_user.dogwalkings.find params[:id]
    end

    def dogwalking_params
      params.require(:dogwalking).permit(:schedule_date, :duration, :latitude, :longitude, :init_hour, :finish_hour, pet_ids: [] )
    end

    def price_calculator pets, duration
      price = 0.0
      if duration == 1 # 30 minutos
        price = 25.0
        price = price + ( (pets - 1) * 15.0 ) if pets > 1
      elsif duration == 2 # 60 minutos
        price = 35.0
        price = price + ( (pets - 1) * 25.0 ) if pets > 1
      end
      price
    end
end
