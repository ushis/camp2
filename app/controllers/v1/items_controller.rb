class V1::ItemsController < V1::ApplicationController
  before_action :find_topic
  before_action :find_list
  before_action :find_item, only: [:show, :update, :destroy]

  # GET /v1/topics/:topic_id/lists/:list_id/items
  def index
    @items = @list.items.order(position: :asc)
    render json: @items
  end

  # GET /v1/topics/:topic_id/lists/:list_id/items/:id
  def show
    render json: @item
  end

  # POST /v1/topics/:topic_id/lists/:list_id/items
  def create
    @item = @list.items.build(item_params)
    authorize @item

    if @item.save
      render json: @item, status: :created
    else
      render json: {errors: @item.errors}, status: :unprocessable_entity
    end
  end

  # PATCH /v1/topics/:topic_id/lists/:list_id/items/:id
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: {errors: @item.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /v1/topics/:topic_id/lists/:list_id/items/:id
  def destroy
    if @item.destroy
      head :no_content
    else
      render json: {errors: @item.errors}, status: :unprocessable_entity
    end
  end

  private

  # Finds the requested topic
  def find_topic
    @topic = current_user.topics.find(params[:topic_id])
  end

  # Finds the requested list
  def find_list
    @list = @topic.lists.find(params[:list_id])
  end

  # Finds the requested item
  def find_item
    @item = @list.items.find(params[:id])
    authorize @item
  end

  # Returns the permitted item attributes
  def item_params
    params
      .require(:item)
      .permit(*ItemPolicy.new(@item || Item).permitted_attributes)
  end
end
