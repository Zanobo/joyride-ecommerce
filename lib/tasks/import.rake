require 'httparty'
require "#{Rails.root}/lib/imports/acumatica_import"

namespace :import do

  desc "Import data from Acumatica"
  task :full_data => :environment do
    AcumaticaImport::import_full_data
  end

  desc "Import Customers from Acumatica"
  task :customers => :environment do
    AcumaticaImport::import_customers
  end

end