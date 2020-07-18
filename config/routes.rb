Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :data_conversions, only: [:index] do
    collection do
      get 'convert_data'
    end
  end
  root to: 'data_conversions#index'
end
