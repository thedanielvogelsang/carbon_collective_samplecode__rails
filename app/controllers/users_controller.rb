class UsersController < ApplicationController
  respond_to :json

  def create
    @user = User.new(safe_params)
    respond_to do |format|
      if params[:user][:password] == params[:user][:passwordConfirmation] && @user.save
        UserMailer.registration(@user).deliver_now
        error = "Please confirm your email address to continue"
        format.json {render :json => {:errors => error}, :status => 401}
      elsif params[:user][:password] != params[:user][:passwordConfirmation]
        error = 'Passwords did not match. Please try again'
        format.json {render :json => {:errors => error}, :status => 401 }
      elsif !@user.errors.messages[:email].empty? && @user.errors.messages[:email][0] != 'has already been taken'
        error = "Email format invalid. If problem continues contact CarbonCollective systems support"
        format.json {render :json => {:errors => error}, :status => 401 }
      else
        error = "Email already taken. Did you forget your password?"
        format.json {render :json => {:errors => error}, :status => 401 }
      end
    end
  end

  def update
    user = User.find(params[:id])
    oldpass = params[:user][:old_password]
    authenticated = authenticate_old_password(user, oldpass)

    # put in clause for updating email to reset email confirm"

    if oldpass && authenticated
      if user.update(safe_params)
        render json: user, status: 200
      else
        render json: {:errors => user.errors.messages}, status: 404
      end
    elsif oldpass && !authenticated
      render json: {:errors => "old password inaccurate, try again"}, status: 404
    elsif !oldpass && user.update(safe_params)
      render json: user, status: 200
    else
      render json: {:errors => 'failure to update, please try again'}, status: 404
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:format])
    if user
      user.email_activate
      flash[:success] = "Welcome to Carbon Collective! Your email has been confirmed.
      Please sign in to the app to continue."
      redirect_to "http://localhost:3001/login-first-time"
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

  private

    def authenticate_old_password(u, pass)
      u.authenticate(pass)
    end

    # def authenticate(user)
    #   if user.authenticate(params[:user][:confirm_password])
    #     update_with_password(user)
    #   else
    #     flash[:error] = "Password confirmation incorrect"
    #     redirect_to settings_path
    #   end
    # end
    #
    # def update_with_password(user)
    #   if user.update(safe_params)
    #     redirect_to user_path(user)
    #   else
    #     flash[:error] = "New password didnt match confirmation"
    #     redirect_to settings_path
    #   end
    # end
    #
    # def update_user(user)
    #   if user.update(safe_params)
    #     redirect_to user_path(user.id) if !user.addresses.empty?
    #     redirect_to new_address_path({id: user.id}) if user.addresses.empty?
    #   else
    #     flash[:error] = "Unsuccessful update, please try again"
    #     redirect_back(fallback_location: user_path(user))
    #   end
    # end

    def safe_params
      params.require('user').permit(:first, :last, :email, :password)
    end
end
