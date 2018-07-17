class UsersController < ApplicationController
  skip_before_action :look_for_token, only: [:invite_accepted]
  respond_to :json

  def create
    #update here for new_users: instead of NEW lets use UPDATE after finding users we've already created
    @user = User.find(params[:user][:id])
    respond_to do |format|
      if params[:user][:password] == params[:user][:passwordConfirmation] && @user.update(safe_params)
        if @user.email_confirmed
          @user.remove_token
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
      user.remove_token
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
    msg = params[:message]
    # write to invites text file here, use UserLogHelper in the MailerHelper
    UserLogHelper.user_invites_someone(user, emails.keys.length, msg)
    MailerHelper.invite(user, emails, msg, user.generation)
    respns = MailerHelper.sort_emails(emails)
    respns == 'success' ? status = 201 : status = 404
    puts respns
    render json: {message: respns}, status: status
  end

  def invite_accepted
    host = 'https://carbon-collective.github.io'
    # host = 'http://localhost:3001'
    prev_user = User.find_by_invite_token(params[:token])
    new_user = User.find(params[:id])
    # UserLogHelper.invite_accepted(prev, new) , write to text file that new_user accepted prev_users invite
    if !new_user.confirm_token
      render :file => 'public/404.html', :status => :not_found, :layout => false
    else
      new_user.email_activate
      UserLogHelper.user_accepts_invite(new_user)
      UserGeneration.find_or_create_by(parent_id: prev_user.id , child_id: new_user.id)
      UserGeneration.bind_generations(prev_user, new_user.id)
      redirect_to "#{host}/signup/#{new_user.id}"
    end
  end

  private

    def authenticate_old_password(u, pass)
      u.authenticate(pass)
    end

    def safe_params
      params.require('user').permit(:id, :first, :last, :email, :password, :privacy_policy)
    end
end
