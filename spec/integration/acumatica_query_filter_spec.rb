require 'rails_helper'
require 'acumatica/synchronizer'

RSpec.describe Acumatica do
  let(:synchronizer) { Acumatica::Synchronizer.new }

  it 'should get the list of restriction groups' do
    expect(synchronizer.get_restriction_groups.class).to eq(Array)
  end

  it 'should get the items filtered by a restriction group' do
    variant = create(:variant)
    expect(synchronizer.get_items_by_restriction_groups('SFITEMS').first).to eq(variant)
  end

  it 'should get the customers filtered by a restriction group' do
    user = create(:user)
    expect(synchronizer.get_customer_by_restriction_groups('NYOFC').first).to eq(user)
  end

  it 'should get the customer orders filtered by customer' do
    expect(synchronizer.get_customer_orders('TWITTER').class).to eq(Array)
  end
end
