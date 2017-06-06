require 'rails_helper'
require 'acumatica/synchronizer'

RSpec.describe Acumatica do
  let(:synchronizer) { Acumatica::Synchronizer.new(autologin: false) }

  it 'should login in to Acumatica ERP' do
    expect(synchronizer.login.response.code).to eq('204')
  end

  it 'should logout from Acumatica ERP' do
    synchronizer.login
    expect(synchronizer.logout.response.code).to eq('204')
  end
end
