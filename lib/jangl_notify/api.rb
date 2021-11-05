require 'jangl_notify/kafka'
require 'time'


module JanglNotify
  class NotificationPlugin < Killbill::Plugin::Notification

    def start_plugin
      config = {}  # get config from tenant properties/global config
      @producer = KafkaProducer.new(config, @logger)
      super
    end

    def stop_plugin
      super
      @producer.close
    end

    def on_event(event)
      write_event event
      nil
    end

    private

    def write_event(event)
      @producer.send({
        :timestamp => (Time.now.to_f * 1000).to_i,
        :event_type => event.event_type.to_s,
        :object_type => event.object_type.to_s,
        :object_id => event.object_id || '',
        :meta_data => event.meta_data || '',
        :account_id => event.account_id || '',
        :tenant_id => event.tenant_id || '',
        :user_token => event.user_token || '',
      })
    end

  end
end