require 'rails_helper'

RSpec.describe AcumaticaSync, type: :worker do
  it 'should create a Sidekiq cron job using Sidekiq-cron gem' do
    Sidekiq::Worker.clear_all
    Sidekiq::Cron::Job.destroy_all!
    job = Sidekiq::Cron::Job.create(name: 'Acumatica Items Sync',
                                    cron: '*/5 * * * *',
                                    class: 'AcumaticaSync',
                                    args: ['items'])
    job = Sidekiq::Cron::Job.find('Acumatica Items Sync')
    job.enque!
    expect(job.status).to eq('enabled')
    expect(Sidekiq::Cron::Job.count).to eq(1)
    expect(Sidekiq::Worker.jobs.size).to eq(1)
  end
end
