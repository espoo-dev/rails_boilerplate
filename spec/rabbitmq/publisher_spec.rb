# spec/services/rabbitmq_publisher_spec.rb

require 'rails_helper'
require 'bunny-mock'

RSpec.describe RabbitmqPublisher do
  let(:exchange_name) { 'test_exchange' }
  let(:routing_key) { 'test_routing_key' }
  let(:rabbitmq_url) { 'amqp://test:test@rabbitmq:5672/' }


    it 'should publish messages to queues' do

    channel = BunnyMock.new(rabbitmq_url).start.channel
    queue = channel.queue 'queue.test'

    queue.publish 'Testing message', priority: 5

    expect(queue.message_count).to eq(1)

    payload = queue.pop
    expect(queue.message_count).to eq(0)

    expect(payload[:message]).to eq('Testing message')
    expect(payload[:options][:priority]).to eq(5)
    end

end
