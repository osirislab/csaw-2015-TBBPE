class PostsController < ApplicationController
  before_filter :set_post, except: [:index, :search, :new, :create]
  before_filter :require_admin, only: [:new, :create, :edit, :update]

  def index
    @posts = Post.all
  end

  def search
    @posts = Post.search(params[:q])
  end

  def show
    @already_voted = @post.votes.where(user: current_user).any?
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create post_params
    if @post.new_record?
      flash.now[:error] = @post.errors.full_messages.to_sentence
      render :new
    else
      redirect_to post_path(@post)
    end
  end

  def edit
  end

  def update
    if @post.update_attributes post_params
      redirect_to post_path(@post)
    else
      flash[:error] = @post.errors.full_messages.to_sentence
      redirect_to edit_post_path(@post)
    end
  end

  def like
    vote +1
  end

  def dislike
    vote -1
  end

  private

  def vote(value)
    record = current_user.votes.new(post: @post, value: value)
    if record.save
      render json: { error: "", votes: @post.score }
    else
      render json: { error: record.errors.full_messages.to_sentence, votes: @post.score }
    end
  end

  def set_post
    @post = Post.find_by_id(params[:id].to_i)
  end

  def post_params
    params.require(:post).permit(:name, :body)
  end
end
