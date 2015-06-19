class V1::ProfilesController < V1::ApplicationController
  skip_before_action :authenticate, only: [:create]

  before_action :find_user, only: [:show, :update, :destroy]

  # GET /v1/profile
  def show
    render json: @user, serializer: ProfileSerializer
  end

  # POST /v1/profile
  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      render json: @user, scope: @user, serializer: ProfileSerializer, status: :created
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # PATCH /v1/profile
  def update
    if !@user.authenticate(password)
      unauthorized
    elsif @user.update(user_params)
      render json: @user, serializer: ProfileSerializer
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /v1/profile
  def destroy
    if !@user.authenticate(password)
      unauthorized
    elsif @user.destroy
      head :no_content
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  private

  # Finds the requested user
  def find_user
    @user = current_user
    authorize @user
  end

  # Returns the :password_current parameter
  def password
    params.require(:user).fetch(:password_current, nil)
  end

  # Returns the permitted user parameters
  def user_params
    params
      .require(:user)
      .permit(*policy(@user || User.new).permitted_attributes)
  end
end
