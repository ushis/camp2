class V1::TopicsController < V1::ApplicationController
  before_action :find_topic, only: [:show, :update, :destroy]

  # GET /v1/topics
  def index
    @topics = current_user.topics.order(name: :asc)
    render json: @topics
  end

  # GET /v1/topics/:id
  def show
    render json: @topic
  end

  # POST /v1/topics
  def create
    @topic = current_user.topics.build(topic_params)
    authorize @topic

    if @topic.save
      render json: @topic, status: :created
    else
      render json: {errors: @topic.errors}, status: :unprocessable_entity
    end
  end

  # PATCH /v1/topics/:id
  def update
    if @topic.update(topic_params)
      render json: @topic
    else
      render json: {errors: @topic.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /v1/topics/:id
  def destroy
    if @topic.destroy
      head :no_content
    else
      render json: {errors: @topic.errors}, status: :unprocessable_entity
    end
  end

  private

  # Finds the requested topic
  def find_topic
    @topic = current_user.topics.find(params[:id])
    authorize @topic
  end

  # Returns the permitted topic parameters
  def topic_params
    params
      .require(:topic)
      .permit(*policy(@topic || Topic.new).permitted_attributes)
  end
end
