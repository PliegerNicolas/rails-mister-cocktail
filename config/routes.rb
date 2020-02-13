Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'cocktails#index'
  resources :cocktails, only: %i[index show new create edit update destroy] do
    resources :doses, only: %i[create new]
  end
  resources :doses, only: [:destroy]
end
