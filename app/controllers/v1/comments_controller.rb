class V1::CommentsController < V1::ApplicationController
  before_action :find_topic
  before_action :find_list
  before_action :find_item
  before_action :find_comment, only: [:show, :update, :destroy]

  # GET /v1/topics/:topic_id/lists/:list_id/items/:item_id/comments
  def index
    @comments = @item.comments.includes(:user).order(created_at: :asc)
    render json: @comments
  end

  # GET /v1/topics/:topic_id/lists/:list_id/items/:item_id/comments/:id
  def show
    render json: @comment
  end

  # POST /v1/topics/:topic_id/lists/:list_id/items/:item_id/comments
  def create
    @comment = @item.comments.build(comment_params)
    authorize @comment

    if @comment.save
      render json: @comment, status: :created
    else
      render json: {errors: @comment.errors}, status: :unprocessable_entity
    end
  end

  # PATCH /v1/topics/:topic_id/lists/:list_id/items/:item_id/comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: {errors: @comment.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /v1/topics/:topic_id/lists/:list_id/items/:item_id/comments/:id
  def destroy
    if @comment.destroy
      head :no_content
    else
      render json: {errors: @comment.errors}, status: :unprocessable_entity
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
    @item = @list.items.find(params[:item_id])
  end

  # Finds the requested comment
  def find_comment
    @comment = @item.comments.find(params[:id])
    authorize @comment
  end

  # Returns the permitted comment parameters
  def comment_params
    params
      .require(:comment)
      .permit(*policy(@comment || Comment.new).permitted_attributes)
  end
end
