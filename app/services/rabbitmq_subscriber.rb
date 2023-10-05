class RabbitmqSubscriber
  def initialize
    @connection = Bunny.new(ENV['RABBITMQ_URL'])
    @connection.start
    @channel = @connection.create_channel
  end

  def subscribe(exchange_name)
    exchange = @channel.topic(exchange_name)
    queue = @channel.queue('', exclusive: true)

    queue.bind(exchange, routing_key: 'key')

    queue.subscribe(block: true) do |delivery_info, properties, body|
      process_message(body)
    end
  end

  def process_message(message)
    puts "Received message: #{message}"
  end

  def close
    @connection.close
  end
end
