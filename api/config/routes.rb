Rails.application.routes.draw do

  namespace :api, defaults: { format: :json }, path: '/' do
    namespace :v1, path: '/' do
      devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'api/v1/sessions',
               registrations: 'api/v1/registrations'
             }

      resources :pets

      resources :dogwalkings, only: [:index, :show, :create] do
        member do
          patch :start_walk
          patch :finish_walk
        end
      end
    end
  end

end
