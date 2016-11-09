Spree::User.class_eval do
  after_create :send_welcome_mail
  after_update :send_approved_email

  def active_for_authentication?
    super && approved?
  end

  def self.ransackable_attributes(auth_object=nil)
    %w[id email approved created_at]
  end

  def send_welcome_mail
    UserMailer.welcome_customer_email(self).deliver
  end

  def send_approved_email
    if approved_changed? && self.approved == true
      UserMailer.approved_customer_email(self).deliver
    end
  end

end