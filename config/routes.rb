Rails.application.routes.draw do
  # get 'survey/index'
  # get 'survey/new'
  # get 'survey/show'
  resources :surveys 

  get 'surveys/new/:subtype', to: 'surveys#new', as: "subtype_survey"


  get '/choose', to: 'surveys#choose', as: 'choose'


  #get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
