Spree::User.class_eval do
  after_create :send_welcome_mail

  def active_for_authentication?
    super && approved?
  end

  def self.ransackable_attributes(auth_object=nil)
    %w[id email approved created_at]
  end

  def send_welcome_mail
    UserMailer.welcome_customer_email(self).deliver
  end

end