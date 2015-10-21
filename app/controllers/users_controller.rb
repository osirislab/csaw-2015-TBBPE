class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You are now logged in as #{@user.login}"
      redirect_to "/"
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :password, :password_confirmation)
  end
end
