class V1::ListsController < V1::ApplicationController
  before_action :find_topic
  before_action :find_list, only: [:show, :update, :destroy]

  # GET /v1/topic/:topic_id/lists
  def index
    @lists = @topic.lists.order(position: :asc)
    render json: @lists
  end

  # GET /v1/topic/:topic_id/lists/:id
  def show
    render json: @list
  end

  # POST /v1/topic/:topic_id/lists
  def create
    @list = @topic.lists.build(list_params)
    authorize @list

    if @list.save
      render json: @list, status: :created
    else
      render json: {errors: @list.errors}, status: :unprocessable_entity
    end
  end

  # PATCH /v1/topic/:topic_id/lists/:id
  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: {errors: @list.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /v1/topic/:topic_id/lists/:id
  def destroy
    if @list.destroy
      head :no_content
    else
      render json: {errors: @list.errors}, status: :unprocessable_entity
    end
  end

  private

  # Finds the requested topic
  def find_topic
    @topic = current_user.topics.find(params[:topic_id])
  end

  # Finds the requested list
  def find_list
    @list = @topic.lists.find(params[:id])
    authorize @list
  end

  # Returns the permitted list parameters
  def list_params
    params
      .require(:list)
      .permit(*ListPolicy.new(@list || List).permitted_attributes)
  end
end
