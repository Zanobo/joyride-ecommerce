Spree::Taxonomy.class_eval do
  def self.find_or_create_by name
    find_by(name: name) || create(name: name)
  end
end
