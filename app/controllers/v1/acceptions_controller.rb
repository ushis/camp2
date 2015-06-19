class V1::AcceptionsController < V1::ApplicationController
  before_action :find_invitation

  # POST /v1/acception
  def create
    @share = @invitation.build_share(user: current_user)
    authorize @share

    if @share.save
      render json: @share, serializer: AcceptionSerializer, status: :created
    else
      render json: {errors: @share.errors}, status: :unprocessable_entity
    end
  end

  private

  # Finds the requested invitation
  def find_invitation
    @invitation = Invitation.find_by_invitation_token!(invitation_token)
  rescue ActiveRecord::RecordNotFound
    render json: {errors: {invitation_token: ['is invalid']}}, status: :forbidden
  end

  # Returns the provided invitation token
  def invitation_token
    params.require(:acception).fetch(:invitation_token, nil)
  end
end
