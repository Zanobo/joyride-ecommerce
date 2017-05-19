require 'rails_helper'
require 'acumatica/import'

RSpec.describe 'acumatica session' do
  it 'should login in Acumatica ERP' do
    expect(Acumatica.login.response.code).to eq('204')
  end

  it 'should logout from Acumatica ERP' do
    expect(Acumatica.logout.response.code).to eq('204')
  end

  xit 'should import all the customers' do
    #TODO: this takes time, I need to fix it
    expect(Acumatica.import_customers.response.code).to eq('200')
  end
end
