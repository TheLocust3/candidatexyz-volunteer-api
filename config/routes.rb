Rails.application.routes.draw do
  get 'volunteers/number_of_pages' => 'volunteers#get_number_of_pages'
  resources :volunteers

  resources :contacts
  
  resources :messages
end
