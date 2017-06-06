class AcumaticaSync
  include Sidekiq::Worker
  sidekiq_options queue: 'synchronizer'

  def perform(args)
    Acumatica::send("import_#{args.first}")
  end
end
