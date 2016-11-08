class UserMailer < ApplicationMailer

    default from: "\"Joyride\" <ecommerce@joyridecoffeedistributers.com>"

    def welcome_customer_email(user)
      @user = user
      @adm_em = 'ecommerce@joyridecoffeedistributers.com'
      @url  = spree.login_path
      mail(to: @user.email, bcc: @adm_em, subject: 'Welcome to Joyride Coffee')
    end

end
