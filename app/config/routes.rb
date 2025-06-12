# frozen_string_literal: true

Discourse::Application.routes.append do
  get "/public_users" => "salla_serializers/public_users#index"
  post "/t/:id/increment_count" => "salla_serializers/topics#increment_count"
end
