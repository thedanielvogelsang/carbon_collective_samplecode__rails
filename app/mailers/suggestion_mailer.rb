class SuggestionMailer < ApplicationMailer

    def send_suggestion(user, body)
        @suggestion = body
        @user = user
        mail(to: 'carboncollective.devops@gmail.com',
             subject: "App Suggestion")
    end

    def send_expansion_request(user, body)
      @body = body
      @mail = user
      mail(to: 'carboncollective.devops@gmail.com',
            subject: "New Requested Area")
    end

    def send_bug_fix_request(user, body)
      @bug = body
      @user = user
      mail(to: 'carboncollective.devops@gmail.com',
            subject: "Bug Fix request")
    end

end
