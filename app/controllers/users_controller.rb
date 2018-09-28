class UsersController < ApplicationController
  skip_before_action :look_for_token, only: [:invite_accepted, :reset_password]
  respond_to :json

  def create
    #update here for new_users: instead of NEW lets use UPDATE after finding users we've already created
    @user = User.friendly.find(params[:user][:id])
    respond_to do |format|
      if params[:user][:password] == params[:user][:passwordConfirmation] && @user.update(safe_params)
        if @user.email_confirmed
          @user.remove_token
          @user.complete_signup
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
    user = User.friendly.find(params[:id])
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
    user = User.friendly.find(params[:user_id])
    house = House.find(params[:house_id])
    if user && house
      UserHouse.create(user_id: user.id,
                      house_id: house.id,
                      move_in_date: DateTime.new(params[:moveInDate])
                            .in_time_zone("Mountain Time (US & Canada)")
                      )
      render json: user
    else
      error = "User could not be added to existing house"
      render json: {errors: error}, status: 401
    end
  end

  def invite
    user = User.friendly.find(params[:id])
    emails = params[:emails]
    msg = params[:message]
    # write to invites text file here, use UserLogHelper in the MailerHelper
    UserLogHelper.user_invites_someone(user, emails.keys.length, msg)
    MailerHelper.invite(user, emails, msg, user.generation)
    respns = MailerHelper.sort_emails(emails)
    respns == 'success' ? status = 201 : status = 404
    render json: {message: respns}, status: status
  end

  def invite_accepted
    # host = 'https://carbon-collective.github.io'
    host = 'http://localhost:3001'
    prev_user = User.find_by_invite_token(params[:token])
    new_user = User.friendly.find(params[:id])
    if !new_user.confirm_token
      render :file => 'public/404.html', :status => :not_found, :layout => false
    elsif UserInvite.where(user_id: prev_user.id, invite_id: new_user.id).exists?
      new_user.email_activate
      UserLogHelper.user_accepts_invite(new_user)
      UserGeneration.find_or_create_by(parent_id: prev_user.id , child_id: new_user.id)
      UserGeneration.bind_generations(prev_user, new_user.id)
      redirect_to "#{host}/signup/#{new_user.slug}"
    else
      render :file => 'public/expired.html', :status => :not_found, :layout => false
    end
  end

  def user_invites
    user = User.friendly.find(params[:user_id])
    invites = user.user_invites.sort_by{|u| u.email_confirmed ? 0 : 1 }
    user_invites = {}
    if !invites.empty?
      invites.each_with_index do |invite, n|
        ui = UserInvite.where(user_id: user.id, invite_id: invite.id).last
        invite.completed_signup? ? time = invite.completed_signup_date : time = ui.created_at
        user_invites[n] = [ui.invite_id, invite.email, time.to_f*1000, time.strftime('%a, %d %b %Y'), invite.completed_signup?]
      end
    end
    render json: user_invites, status: 200
  end

  def cancel_invite
    user = User.friendly.find(params[:user_id])
    invite = User.find(params[:invite_id])
    UserInvite.where(user_id: user.id, invite_id: invite.id).first.destroy
    render json: invite, status: 202
  end

  def clear_account
    user = User.friendly.find(params[:user_id])
    if user.clear_account
      render :json => {status: 202}
    else
      render :json => {status: 404}
    end
  end

  def reset_password_email
    user = User.find_by(email: params[:user][:email])
    if user
      MailerHelper.reset_password(user)
      render :json => {status: 202}
    else
      error = "Could not find an account with that email. Please try again."
      render :json => {:errors => error}, status: 404
    end
  end

  def reset_password
    host = 'https://carbon-collective.github.io'
    # host = 'http://localhost:3001'
    user = User.find_by_confirm_token(params[:token])
    if !user
      render :file => 'public/expired.html', :status => :not_found, :layout => false
    else
      redirect_to "#{host}/reset-password/#{user.id}"
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
