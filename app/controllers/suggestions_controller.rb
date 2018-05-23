class SuggestionsController < ApplicationController

  def send_suggestion
    user = User.find(params[:user][:id])
    mail = SuggestionMailer.send_suggestion(user, params[:email_body])
    mail.deliver_now
    render json: {:success => "Message sent"}, status: 204
  end

  def region_expansion
    user = User.find(params[:user][:id])
    mail = SuggestionMailer.send_expansion_request(user, params[:email_body])
  end
end
