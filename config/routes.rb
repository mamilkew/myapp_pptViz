Rails.application.routes.draw do

  get 'pages/info'
  get 'pages/home'
  get 'pages/timeline'
  get 'pages/country_map'
  get 'pages/convertcsv', to: 'pages#convertcsv'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root 'application#hello' # root 'controller_name#action_name'



  resources :ideas
  root to: redirect('/ideas')

end
