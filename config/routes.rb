Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :contacts, only: %i[new create index show]

  root 'contacts#index'
end
