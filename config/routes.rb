Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :profiles

  root 'hotel#index'
  get 'hotel/index' => 'hotel#index'
  get 'hotel/show' => 'hotel#show'
  get 'timetables/index' => 'timetables#index'
  get 'charts/index' => 'charts#index'
  get 'charts/show_annual' => 'charts#show_annual'
  get 'charts/show_monthly' => 'charts#show_monthly'

  get 'bookings/search' => 'bookings#search'
  get 'bookings/result' => 'bookings#result'
  get 'bookings/preconfirm' => 'bookings#preconfirm'

  get 'files/index' => 'files#index'
  get 'files/show' => 'files#show'
# get 'files/return' => 'files#return'

  get 'files/create' => 'files#create'
  get 'files/update' => 'files#update'
  delete 'files/destroy' => 'files#destroy'

  get 'files/view_pdf' => 'files#view_pdf'
  get 'files/download' => 'files#download'
  post 'files/upload' => 'files#upload'

  post 'upload'=>'categories#upload'

  resources :customers
  resources :bookings
  resources :invoices do
    resources :customer
    resources :bookings
  end

  resources :categories do
    resources :rooms
  end
  resources :rooms
  resources :contents
  resources :components
  resources :themes

  unauthenticated do
    root :to => 'home#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
