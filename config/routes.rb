Rails.application.routes.draw do
  root to: 'root#index'

  get 'volunteers/number-of-pages' => 'volunteers#get_number_of_pages'
  resources :volunteers, defaults: { format: :json }

  resources :contacts, defaults: { format: :json }
  
  resources :messages, defaults: { format: :json }

  get 'analytic_entries/aggregate' => 'analytic_entries#aggregate'
  resources :analytic_entries, defaults: { format: :json }
  get 'ip' => 'analytic_entries#ip'

  resources :images

  resources :receipts, defaults: { format: :json }
  
  resources :expenditures, defaults: { format: :json }

  resources :in_kinds, defaults: { format: :json }
  
  resources :liabilities, defaults: { format: :json }
end
