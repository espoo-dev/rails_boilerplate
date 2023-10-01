require 'rails_helper'

RSpec.describe HardJob, type: :job do
  it 'should perform the job' do
    # Basic
    expect { HardJob.perform_async }.to enqueue_sidekiq_job

    # A specific job class
    expect { HardJob.perform_async }.to enqueue_sidekiq_job(HardJob)

    # with specific arguments
    expect { HardJob.perform_async "HardJob!" }.to enqueue_sidekiq_job.with("HardJob!")

    # On a specific queue
    expect { HardJob.set(queue: "high").perform_async }.to enqueue_sidekiq_job.on("high")

    # At a specific datetime
    specific_time = 1.hour.from_now
    expect { HardJob.perform_at(specific_time) }.to enqueue_sidekiq_job.at(specific_time)

    # In a specific interval (be mindful of freezing or managing time here)
    freeze_time do
      expect { HardJob.perform_in(1.hour) }.to enqueue_sidekiq_job.in(1.hour)
    end

    # Combine and chain them as desired
    expect { HardJob.perform_at(specific_time, "HardJob!") }.to(
      enqueue_sidekiq_job(HardJob)
      .with("HardJob!")
      .on("default")
      .at(specific_time)
    )
  end
end
