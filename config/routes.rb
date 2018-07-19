Rails.application.routes.draw do
  root to: 'root#index'

  get 'volunteers/number-of-pages' => 'volunteers#get_number_of_pages'
  get 'volunteers/export' => 'volunteers#export', defaults: { format: :csv }
  resources :volunteers, defaults: { format: :json }

  get 'contacts/export' => 'contacts#export', defaults: { format: :csv }
  resources :contacts, defaults: { format: :json }
  
  get 'messages/export' => 'messages#export', defaults: { format: :csv }
  resources :messages, defaults: { format: :json }

  get 'analytic_entries/aggregate' => 'analytic_entries#aggregate'
  resources :analytic_entries, defaults: { format: :json }
  get 'ip' => 'analytic_entries#ip'

  resources :images

  get 'receipts/export' => 'receipts#export', defaults: { format: :csv }
  resources :receipts, defaults: { format: :json }
  
  get 'expenditures/export' => 'expenditures#export', defaults: { format: :csv }
  resources :expenditures, defaults: { format: :json }

  get 'in_kinds/export' => 'in_kinds#export', defaults: { format: :csv }
  resources :in_kinds, defaults: { format: :json }
  
  get 'liabilities/export' => 'liabilities#export', defaults: { format: :csv }
  resources :liabilities, defaults: { format: :json }

  resources :reports, defaults: { format: :json }
  get 'report_types' => 'reports#report_types'

  resources :committees, defaults: { format: :json }
  get 'committee_by_campaign' => 'committees#get_campaign_committee', defaults: { format: :json }
end
