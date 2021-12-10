Rails.application.routes.draw do
  resources :items
  resources :banners
  resources :users
  get 'main', to: 'main#main'
  get 'register', to: 'main#register'
  post 'register', to: 'main#create_user'
  post 'main', to: 'main#login'
  get 'banner', to: 'main#banner'
  post 'roll', to: 'main#roll'
  get 'inventory', to: 'main#inventory'
  post 'sellItem', to: 'main#sellItem'
  get 'market', to: 'main#market'
  post 'buy', to: 'main#buy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
