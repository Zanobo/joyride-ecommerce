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

  def self.find_or_create_by customer
    user = find_by(email: customer['MainContact']['Email']['value'])
    user || Spree::User.new({
      email:        customer['MainContact']['Email']['value'],
      first_name:   customer['MainContact']['FirstName']['value'],
      last_name:    customer['MainContact']['LastName']['value'],
      company_name: customer['CustomerID']['value'],
      price_class:  customer['PriceClassID']['value'],
      branch:       customer['ShippingBranch']['value'],
      password:     'testpassword'
    })
  end
end
