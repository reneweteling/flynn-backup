class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def challenge
    render plain: AcmeCert.find_by(token: params[:token]).file_content
  end
end
