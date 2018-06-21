class SuggestionsController < ApplicationController

  def send_suggestion
    user = User.find(params[:user][:id])
    mail = SuggestionMailer.send_suggestion(user, params[:email_body])
    mail.deliver_now
    render json: {:success => "Message sent"}, status: 202
  end

  def region_expansion
    user = User.find(params[:user][:id])
    mail = SuggestionMailer.send_expansion_request(user, params[:email_body])
    mail.deliver_now
    render json: {:success => "Message sent"}, status: 202
  end

  def send_bug
    user = User.find(params[:user][:id])
    mail = SuggestionMailer.send_bug_fix_request(user, params[:email_body])
    mail.deliver_now
    render json: {:success => "Message sent"}, status: 202
  end
end
