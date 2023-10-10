# frozen_string_literal: true

class RabbitmqPublisher
  def initialize
    @connection = Bunny.new(ENV.fetch("RABBITMQ_URL", nil))
    @connection.start
    @channel = @connection.create_channel
  end

  def publish(exchange_name, message)
    exchange = @channel.topic(exchange_name)
    exchange.publish(message, routing_key: "key")
  end

  def close
    @connection.close
  end
end
