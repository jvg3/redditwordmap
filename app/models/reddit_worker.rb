class RedditWorker
  include Sidekiq::Worker

  # Sidekiq::Cron::Job.all
  # Sidekiq::Cron::Job.create(name: 'reddit_worker', cron: '*/5 * * * *', class: 'RedditWorker')
  def perform(*args)
    puts "STARTING GET_REDDIT_DATA"
    RedditAdapter.get_reddit_data
    puts "DONE GET_REDDIT_DATA"
  end
end