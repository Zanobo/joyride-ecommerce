Spree::User.class_eval do
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.ransackable_attributes(auth_object=nil)
    %w[id email approved created_at]
  end
end