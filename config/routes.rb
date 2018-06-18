Rails.application.routes.draw do
  root to: 'root#index'

  get 'volunteers/number-of-pages' => 'volunteers#get_number_of_pages'
  resources :volunteers, defaults: { format: :json }

  delete 'contacts/unsubscribe' => 'contacts#unsubscribe'
  resources :contacts, defaults: { format: :json }
  
  resources :messages, defaults: { format: :json }
end
