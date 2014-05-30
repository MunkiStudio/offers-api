require 'sidekiq/web'

Rails.application.routes.draw do
  mount API::Base => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'
  mount Sidekiq::Web, at:'/sidekiq'
end
