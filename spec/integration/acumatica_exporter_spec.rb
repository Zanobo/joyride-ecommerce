require 'rails_helper'
require 'acumatica/synchronizer'

RSpec.describe Acumatica do
  let(:synchronizer) { Acumatica::Synchronizer.new }

  it 'should export a order for a customer' do
    body = {
      'CustomerID' => { 'value' => 'TECHSPAC' },
      'Description' => { 'value' => 'This is a test Order' },
      'Date' => { 'value' => Time.now.iso8601 },
      'LocationID' => { 'value' => 'MAIN' },
      'OrderedQty' => { 'value' => 1.0 },
      'OrderTotal' => { 'value' => 73.75 },
      'OrderType' => { 'value' => 'RC' },
      'ShipVia' => { 'value' => 'JOYRIDE' }
    }

    expect(synchronizer.export_orders(body)['Description']['value'])
      .to eq('This is a test Order')
  end
end
