require 'jangl_notify/schema'
require 'jangl_notify/utils'

require 'jbundler'
java_import 'org.apache.kafka.clients.producer.ProducerRecord'


module JanglNotify
  class KafkaProducer
    include ::JanglNotify::KillbillLoggerMixin

    def initialize(config = {}, logger = nil)
      @topic_name = config.fetch(:kafka_topic_name, 'killbill-notify')
      @config = config
      @logger = logger
      
      @producer = create_producer
      @schema = AvroSchemaEncoder.new(config, logger)
    end

    def close
      @producer.close
    end

    def send(message)
      encoded = @schema.encode(message)
      @producer.send ProducerRecord.new(@topic_name, encoded)
    end

    private

    def create_producer
      begin
        props = java.util.Properties.new
        kafka = org.apache.kafka.clients.producer.ProducerConfig
        default_properties = [
          [kafka::ACKS_CONFIG, :kafka_acks, '1'],
          [kafka::BATCH_SIZE_CONFIG, :kafka_batch_size, '16384'],
          [kafka::BOOTSTRAP_SERVERS_CONFIG, :kafka_bootstrap_servers, 'kafka.localhost:9092'],
          [kafka::BUFFER_MEMORY_CONFIG, :kafka_buffer_memory, '33554432'],
          [kafka::COMPRESSION_TYPE_CONFIG, :kafka_compression_type, 'none'],
          [kafka::CLIENT_ID_CONFIG, :kafka_client_id, nil],
          [kafka::KEY_SERIALIZER_CLASS_CONFIG, :kafka_key_serializer_class, 'org.apache.kafka.common.serialization.StringSerializer'],
          [kafka::LINGER_MS_CONFIG, :kafka_linger_ms, '0'],
          [kafka::MAX_REQUEST_SIZE_CONFIG, :kafka_max_request_size, '1048576'],
          [kafka::METADATA_MAX_AGE_CONFIG, :kafka_metadata_max_age_ms, nil],
          [kafka::RECEIVE_BUFFER_CONFIG, :kafka_receive_buffer_bytes, nil],
          [kafka::RECONNECT_BACKOFF_MS_CONFIG, :kafka_reconnect_backoff_ms, nil],
          [kafka::REQUEST_TIMEOUT_MS_CONFIG, :kafka_request_timeout_ms, nil],
          [kafka::RETRIES_CONFIG, :kafka_retries, nil],
          [kafka::RETRY_BACKOFF_MS_CONFIG, :kafka_retry_backoff_ms, '100'],
          [kafka::SEND_BUFFER_CONFIG, :kafka_send_buffer, '131072'],
          [kafka::VALUE_SERIALIZER_CLASS_CONFIG, :kafka_value_serializer_class, 'org.apache.kafka.common.serialization.ByteArraySerializer'],
        ]
        
        default_properties.each do |prop_name, setting, default|
          prop_value = @config.fetch(setting, default)
          props.put(prop_name, prop_value.to_s) unless prop_value.nil?
        end

        org.apache.kafka.clients.producer.KafkaProducer.new(props)
      rescue => e
        @logger.error('Unable to create Kafka producer from given configuration')
        raise e
      end
    end

  end
end