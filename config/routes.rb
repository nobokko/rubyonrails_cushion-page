Rails.application.routes.draw do
  get 'cushions/', to: 'cushions#index'
  get 'cushions/:url', to: 'cushions#show', constraints: { url: /.+/ }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
