class V1::SharesController < V1::ApplicationController
  before_action :find_topic
  before_action :find_share, only: [:show, :destroy]

  # GET /v1/topic/:topic_id/shares
  def index
    @shares = @topic.shares.includes(:user)
    render json: @shares
  end

  # GET /v1/topic/:topic_id/shares/:id
  def show
    render json: @share
  end

  # DELETE /v1/topic/:topic_id/shares/:id
  def destroy
    if @share.destroy
      head :no_content
    else
      render json: {errors: @share.errors}, status: :unprocessable_entity
    end
  end

  private

  # Finds the requested topic
  def find_topic
    @topic = current_user.topics.find(params[:topic_id])
  end

  # Finds the requested share
  def find_share
    @share = @topic.shares.find(params[:id])
    authorize @share
  end

  # Returns the permitted share parameters
  def share_params
    params
      .require(:share)
      .permit(*SharePolicy.new(@share || Share).permitted_attributes)
  end
end
