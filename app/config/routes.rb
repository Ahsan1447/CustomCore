# frozen_string_literal: true

Discourse::Application.routes.append do
  post "/t/:id/increment_count" => "salla_serializers/topics#increment_count"
  get "/public-users" => "public_users#index"
end
