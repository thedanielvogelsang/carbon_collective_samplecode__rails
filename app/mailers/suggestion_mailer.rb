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
            subject: "User Requested Area")
    end

    def send_geographical_data(user, geog_body)
      area = geog_body[:area]
      id = geog_body[:id]
      @user = user
      uId = user.id
      req = UserRequestArea.create(area_type: area, area_id: id, user_id: uId)
      @area = req.area.name
      mail(to: 'carboncollective.devops@gmail.com',
            subject: "Automatic Area Request")
    end

    def send_bug_fix_request(user, body)
      @bug = body
      @user = user
      mail(to: 'carboncollective.devops@gmail.com',
            subject: "Bug Fix request")
    end

end
