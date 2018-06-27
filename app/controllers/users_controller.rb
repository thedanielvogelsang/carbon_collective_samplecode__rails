class UsersController < ApplicationController
  respond_to :json

  def create
    #update here for new_users: instead of NEW lets use UPDATE after find_or_create_by
    @user = User.find(params[:user][:id])
    respond_to do |format|
      if params[:user][:password] == params[:user][:passwordConfirmation] && @user.update(safe_params)
        if @user.email_confirmed
          format.json {render :json => @user, :status => 201}
        else
        # Not being used currently; For delivering to unregistered emails; signup without invite will work with other FE new_user component
          UserMailer.registration(@user).deliver_now
          error = "Please confirm your email address to continue"
          format.json {render :json => {:errors => error}, :status => 401}
        end
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
    host = 'https://carbon-collective.github.io'
    # host = 'http://localhost:3001'
    if user
      user.email_activate
      flash[:success] = "Welcome to Carbon Collective! Your email has been confirmed.
      Please sign in to the app to continue."
      redirect_to "#{host}/login-first-time"
    else
      flash[:error] = "Sorry. Page Invalid"
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def old_houses
    user = User.find(params[:user_id])
    house = House.find(params[:house_id])
    if user && house
      user.houses << house
      user.set_default_ranks
      render json: user
    else
      error = "User could not be added to existing house"
      render json: {errors: error}, status: 401
    end
  end

  def invite
    user = User.find(params[:id])
    emails = params[:emails]
    message = params[:message]
    UserMailer.invite(user, emails, message, user.generation).deliver_now
    message = sort_emails(emails)
    message == 'success' ? status = 201 : status = 404
    render json: {message: message}, status: status
  end

  def invite_accepted
    host = 'https://carbon-collective.github.io'
    # host = 'http://localhost:3001'
    prev_user = User.find_by_invite_token(params[:token])
    new_user = User.find(params[:id])
    new_user.email_activate
    UserGeneration.find_or_create_by(parent_id: prev_user.id , child_id: new_user.id)
    UserGeneration.bind_generations(prev_user, new_user.id)
    redirect_to "#{host}/signup/#{new_user.id}"
  end

  private

    def authenticate_old_password(u, pass)
      u.authenticate(pass)
    end

    def sort_emails(emails)
      ct = emails.keys.length - 1
      invited_yet = (0..ct).map do |e|
          e = e.to_s
          addr = emails[e]
          u = User.find_by(email: addr)
          u.email_confirmed ? u.email : nil
      end
      if invited_yet.compact.empty?
        message = 'success'
      else
        message = invited_yet.compact
      end
      message
    end

    def safe_params
      params.require('user').permit(:id, :first, :last, :email, :password, :privacy_policy)
    end
end
