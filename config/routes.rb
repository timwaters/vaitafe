Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :users, only: [:index, :show]

  # get 'survey/index'
  # get 'survey/new'
  # get 'survey/show'
  resources :surveys 
  get '/surveys/:id/destroy_image/:image_id' => 'surveys#destroy_image', :as => "destroy_image"

  get 'surveys/new/:subtype', to: 'surveys#new', as: "subtype_survey"


  get '/choose', to: 'surveys#choose', as: 'choose'


  #get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get '/help', to: 'home#help', as: 'help'
  get '/data', to: 'home#data', as: 'data'
  get '/contact', to: 'home#contact', as: 'contact'
end
