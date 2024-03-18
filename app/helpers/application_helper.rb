module ApplicationHelper
    def current_date
        @current_date ||= Date.today.strftime("%Y-%m-%d")
    end
end
