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
end
