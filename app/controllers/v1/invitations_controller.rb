class V1::InvitationsController < V1::ApplicationController
  before_action :find_topic
  before_action :find_invitation, only: [:show, :update, :destroy]

  # GET /v1/topic/:topic_id/invitations
  def index
    @invitations = @topic.invitations
    render json: @invitations
  end

  # GET /v1/topic/:topic_id/invitations/:id
  def show
    render json: @invitation
  end

  # POST /v1/topic/:topic_id/invitations
  def create
    @invitation = @topic.invitations.build(invitation_params)
    authorize @invitation

    if @invitation.save
      render json: @invitation, status: :created
    else
      render json: {errors: @invitation.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /v1/topic/:topic_id/invitations/:id
  def destroy
    if @invitation.destroy
      head :no_content
    else
      render json: {errors: @invitation.errors}, status: :unprocessable_entity
    end
  end

  private

  # Finds the requested topic
  def find_topic
    @topic = current_user.topics.find(params[:topic_id])
  end

  # Finds the requested invitation
  def find_invitation
    @invitation = @topic.invitations.find(params[:id])
    authorize @invitation
  end

  # Returns the permitted invitation parameters
  def invitation_params
    params
      .require(:invitation)
      .permit(*policy(@invitation || Invitation.new).permitted_attributes)
  end
end
