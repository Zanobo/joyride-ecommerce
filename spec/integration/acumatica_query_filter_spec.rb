require 'rails_helper'
require 'acumatica/synchronizer'

RSpec.describe Acumatica do
  let(:synchronizer) { Acumatica::Synchronizer.new }

  it 'should get the list of restriction groups' do
    expect(synchronizer.get_restriction_groups.class).to eq(Array)
  end

  it 'should get the items filtered by a restriction group' do
    # TODO: we need to create an object (with Factory Girl maybe) so we can test
    # that object is found in the DB
    expect(synchronizer.get_items_by_restriction_groups('SFITEMS').class)
      .to eq(Spree::Variant::ActiveRecord_Relation)
  end

  it 'should get the customers filtered by a restriction group' do
    # TODO: we need to create an object (with Factory Girl maybe) so we can test
    # that object is found in the DB
    expect(synchronizer.get_customer_by_restriction_groups('NYOFC').class)
      .to eq(Spree::User::ActiveRecord_Relation)
  end
end
