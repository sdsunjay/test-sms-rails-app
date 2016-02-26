class UsersController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_user, :finish_signup
  before_filter :ensure_signup_complete, only: [:new, :create, :index, :destroy]
  def index
       @users = User.all.order(created_at: :desc)
  end


  def edit
        @user = User.find(params[:id])
        # authorize! :update, @user
  end
  def update
  @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { redirect_to @user, notice: 'Errors.' }
      end
    end   
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
      if current_user.compare_pin_to(params[:user][:pin])
	current_user.set_phone_number_to_verified
        flash[:notice] = "Pin Verified"
        redirect_to root_path
    else
        flash[:notice] = "Pin NOT Verified"
    	render 'finish_signup'
    end
  end

  private
   
  def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email, :phone_number, :pin, :phone_number_verified] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
