class SuggestionsController < ApplicationController

  def send_suggestion
    user = User.friendly.find(params[:user][:id])
    msg = params[:email_body]
    UserLogHelper.user_sends_suggestion(user, msg)
    mail = SuggestionMailer.send_suggestion(user, msg)
    mail.deliver_now
    render json: {:success => "Message sent"}, status: 202
  end

  def region_expansion
    user = User.friendly.find(params[:user][:id])
    UserLogHelper.user_sends_suggestion(user, params[:email_body])
    mail = SuggestionMailer.send_expansion_request(user, params[:email_body])
    mail.deliver_now
    render json: {:success => "Message sent"}, status: 202
  end

  def region_data
    user = User.friendly.find(params[:user][:id])
    UserLogHelper.user_chooses_unsupported_region(user, params[:geographical_data])
    mail = SuggestionMailer.send_geographical_data(user, params[:geographical_data])
    mail.deliver_now
    render json: {:success => "regions stored"}, status: 202
  end

  def send_bug
    user = User.friendly.find(params[:user][:id])
    msg = params[:email_body]
    UserLogHelper.user_finds_bug(user, msg)
    mail = SuggestionMailer.send_bug_fix_request(user, msg)
    mail.deliver_now
    render json: {:success => "Bug fix request sent"}, status: 202
  end
end
