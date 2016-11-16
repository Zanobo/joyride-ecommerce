Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :confirm
    go_to_state :complete
    remove_transition :from => :address, :to => :confirm
  end
  insert_checkout_step :schedule, :after => :address

end