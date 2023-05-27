class ApplicationController < ActionController::Base
    before_action :set_current_user

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, :alert => exception.message
        end

    private
  
    def set_current_user
      @current_user = current_user
    end
end
