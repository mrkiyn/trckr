Rails.application.routes.draw do
  get 'my_task', to: 'main#tasks'
  devise_for :users
  
  resources :categories, except: [:new, :edit] do
    resources :tasks, except: [:index, :new, :edit]
  end
  
  root 'main#home'
  
end
