class UsersController < ApplicationController


  def show
    @user = User.find(params[:id])
    # debugger
    end


  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_url(@user)
    else
      # Handle an unsuccessful save.
      # Redirect to the 'new' view
      render 'new'
    end
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update
      render 'show'
    else
      # Handle an unsuccessful update
      render 'edit'
    end
  end


  private
    def user_params
      # Require name, only permit the fields we explicitly accept
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end


end
