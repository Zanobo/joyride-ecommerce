require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome email" do
    sample_user = Spree::User.new(:email => 'test@example.com', :password => 'password',
                                  :password_confirmation => 'password', :first_name => 'Nolan', :last_name => "Zandi",
                                  :company_name => 'Zanobo Partners')
    user_email = UserMailer.welcome_customer_email(sample_user)
    # Send the email, then test that it got queued
    assert_emails 1 do
      user_email.deliver
    end
  end

  test "approved email" do

  end
end
