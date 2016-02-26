class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
       @users = User.all.order(created_at: :desc)
  end


  def edit
        @user = User.find(params[:id])
        # authorize! :update, @user
  end
  def update
        @user = User.find(params[:id])
        # authorize! :update, @user
  end
  def destroy
      # authorize! :delete, @user
      @user = User.find(params[:id])

      @user = User.destroy(params[:id])
      if @user
          flash[:notice] = "User Removed"
          redirect_to root_path
      else
          render 'destroy'
      end
  end
  def verify
    current_user.verify_phone_number(params[:pin])
    #respond_to do |format|
    #  format.js
    #end
  end

end
