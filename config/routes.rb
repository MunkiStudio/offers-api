require 'sidekiq/web'

# Rails.application.routes.draw do
OffersApi::Application.routes.draw do
  # root "application#index"
  root "grape_swagger_rails/application#index"
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount API::Base => '/api'
  mount Sidekiq::Web =>'/sidekiq'
  
  # match '*path', via: :all, to: 'application#error_404'
end
