class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    private

    def current_date
        @current_date ||= Date.today.strftime("%Y-%m-%d")
    end
end
