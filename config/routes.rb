require 'sidekiq/web'

Rails.application.routes.draw do
  mount API::Base => '/api'
  mount Sidekiq::Web, at:'/sidekiq'
  match '*path', via: :all, to: 'application#error_404'
end
