Rails.application.routes.draw do
  resources :redeem_codes
  resources :items
  resources :banners
  resources :users
  get 'main', to: 'main#main'
  get 'register', to: 'main#register'
  post 'register', to: 'main#create_user'
  post 'main', to: 'main#login'
  get 'banner', to: 'main#banner'
  post 'roll', to: 'main#roll'
  post 'roll10', to: 'main#roll10'
  get 'inventory', to: 'main#inventory'
  post 'sellItem', to: 'main#sellItem'
  get 'market', to: 'main#market'
  post 'buy', to: 'main#buy'
  get 'transaction', to: 'main#transaction'
  post 'like', to: 'main#like'
  post 'unlike', to: 'main#unlike'
  get 'redeem', to: 'main#redeem_display' 
  post 'redeem', to: 'main#redeem' 
  get 'favorite', to: 'main#favorite'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
