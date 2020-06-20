class PlaceMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(places_json, email)
    @places_json = places_json
    @email = email
    # @user = params[:user]
    mail(to: @email, subject: 'Result')
  end
end
