require 'httparty'
require "#{Rails.root}/lib/acumatica/import"

namespace :import do
  desc 'Import Items from Acumatica'
  task items: :environment do
    Acumatica::delay(queue: 'import').import_items
  end

  desc 'Import Customers from Acumatica'
  task customers: :environment do
    Acumatica::delay(queue: 'import').import_customers
  end
end
