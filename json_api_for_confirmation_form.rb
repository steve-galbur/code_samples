class Api::V1::ConfirmationsController < Devise::ConfirmationsController
  before_filter :validate_confirmation_token, :only => :show
  include Devise::Controllers::Helpers
  include ApiHelper
  respond_to :json

  def show
    sign_in(:user, resource)
    resource.ensure_authentication_token!
    redirect_to root_path
  end

  def create
    resource = User.send_confirmation_instructions( {email: params[:user][:email]} )
    if successfully_sent?(resource)
      render :json=> {:success => true }
    else
      render :status => 404, :json => resource.errors.messages
    end
  end
end
