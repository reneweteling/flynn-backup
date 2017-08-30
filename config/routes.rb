Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'admin/apps#index'

  get '.well-known/acme-challenge/:token', to: 'application#challenge'
end
