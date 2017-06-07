require 'rails_helper'
require 'acumatica/synchronizer'

RSpec.describe Acumatica do
  let(:synchronizer) { Acumatica::Synchronizer.new }

  it 'should import all the customers' do
    synchronizer.import_customers(2)

    expect(Spree::User.count).to eq(2)
  end

  it 'should import all the items' do
    synchronizer.import_items(2)

    expect(Spree::Taxonomy.count).to eq(1)
    expect(Spree::Taxon.count).to eq(2)
    expect(Spree::Property.count).to eq(3)
    expect(Spree::Product.count).to eq(2)
    expect(Spree::Variant.count).to eq(2)
    expect(Spree::Product.last.master).to eq(Spree::Variant.last)
    expect(Spree::Variant.last.product).to eq(Spree::Product.last)
  end
end
