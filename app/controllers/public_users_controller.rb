module ::CustomCore
  class PublicUsersController < ::ApplicationController
    skip_before_action :check_xhr
    skip_before_action :ensure_logged_in
  
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