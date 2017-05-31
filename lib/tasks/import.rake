require 'httparty'
require "#{Rails.root}/lib/acumatica/import"

namespace :import do
  desc 'Import Items from Acumatica'
  task items: :environment do
    AcumaticaImport::import_items
  end

  desc 'Import Customers from Acumatica'
  task customers: :environment do
    AcumaticaImport::import_customers
  end

  desc 'Clear Product and Variant data'
  task clear_product_data: :environment do
    puts 'Deleting Product data'
    AcumaticaImport::clear_product_data
    puts 'Deleting Variant data'
    AcumaticaImport::clear_variant_data
  end
end
