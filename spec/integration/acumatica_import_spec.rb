require 'rails_helper'
require 'acumatica/import'

RSpec.describe 'acumatica session' do
  it 'should login in Acumatica ERP' do
    expect(Acumatica.login.response.code).to eq('204')
  end

  it 'should logout from Acumatica ERP' do
    expect(Acumatica.logout.response.code).to eq('204')
  end

  it 'should import all the customers' do
    Acumatica.import_customers(2)
    expect(Spree::User.count).to eq(2)
  end

  it 'should import all the items' do
    Acumatica.import_items(2)
    expect(Spree::Taxonomy.count).to eq(1)
    expect(Spree::Taxon.count).to eq(2)
    expect(Spree::Property.count).to eq(3)
    expect(Spree::Product.count).to eq(2)
    expect(Spree::Variant.count).to eq(2)
    expect(Spree::Product.last.master).to eq(Spree::Variant.last)
    expect(Spree::Variant.last.product).to eq(Spree::Product.last)
  end
end
