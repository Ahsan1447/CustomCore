# frozen_string_literal: true

Discourse::Application.routes.draw do
  scope module: 'custom_core' do
    post "/t/:id/increment_count" => "topics#increment_count"
    get "/public_users" => "public_users#index"
  end
end
