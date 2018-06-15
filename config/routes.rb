Rails.application.routes.draw do
  get 'volunteers/number_of_pages' => 'volunteers#get_number_of_pages'
  resources :volunteers

  delete 'contacts/unsubscribe' => 'contacts#unsubscribe'
  resources :contacts
  
  resources :messages
end
