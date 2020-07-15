module Sidekiq
  # Captures Sidekiq logging for Honeycomb
  class HoneycombMiddleware
    # @param [Object] worker the worker instance
    # @param [Hash] job the full job payload
    #   * @see https://github.com/mperham/sidekiq/wiki/Job-Format
    # @param [String] queue the name of the queue the job was pulled from
    # @yield the next middleware in the chain or worker `perform` method
    # @return [Void]
    def call(worker, job, queue) # rubocop:disable MethodLength
      if Honeycomb.client.nil?
        yield
        return
      end

      Honeycomb.start_span(name: 'sidekiq.job') do |span|
        span.add_field('sidekiq.class', worker.class.name)
        span.add_field('sidekiq.queue', queue)
        span.add_field('sidekiq.jid', job['jid'])
        span.add_field('sidekiq.args', job['args'])
        begin
          yield
          span.add_field('sidekiq.result', 'success')
        rescue StandardError => ex
          span.add_field('sidekiq.result', 'error')
          span.add_field('sidekiq.error', ex.message)
          raise ex
        end
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::HoneycombMiddleware
  end
end

