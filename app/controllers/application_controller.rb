class ApplicationController < ActionController::Base
  before_action :set_locale

  protect_from_forgery with: :exception
  before_action :configure_strong_params, if: :devise_controller?

  def after_sign_in_path_for(user)
    #stored_location_for(user) || bookings_path
    bookings_path
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def configure_strong_params

    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    user_params.permit(:email, :password, :password_confirmation)
    end
  end
end
