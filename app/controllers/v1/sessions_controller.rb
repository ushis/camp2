class V1::SessionsController < V1::ApplicationController
  skip_before_action :authenticate

  skip_after_action :verify_authorized

  # POST /v1/session
  def create
    @user = User.find_by(email: email)

    if @user.try(:authenticate, password)
      render json: @user, scope: @user, serializer: SessionSerializer, status: :created
    else
      unauthorized
    end
  end

  private

  # Returns the email parameter
  def email
    params.require(:user).fetch(:email, nil)
  end

  # Returns the password parameter
  def password
    params.require(:user).fetch(:password, nil)
  end
end
