# frozen_string_literal: true

module SallaSerializers
  class PublicUsersController < ::ApplicationController
    requires_login false
    skip_before_action :check_xhr,
                      :verify_authenticity_token,
                      :redirect_to_login_if_required,
                      only: [:index]
  
    def index
      Rails.logger.info("#############################PublicUsersController#Index#################")
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = 50
  
      users = User
        .where(active: true)
        .order(:id)
        .offset((page - 1) * per_page)
        .limit(per_page)
        .pluck(:id, :username, :name, :created_at)
  
      render json: {
        users: users.map { |id, username, name, created_at|
          { id: id, username: username, name: name, created_at: created_at }
        },
        page: page
      }
    end
  end
end