require 'jangl_notify/utils'
require 'avro'
require 'schema_registry'
require 'schema_registry/client'

AVRO_SCHEMA_FILE = '../schemas/killbill-notify.avro'
MAGIC_BYTE = 0

module JanglNotify
  class AvroSchemaEncoder
    include ::JanglNotify::KillbillLoggerMixin

    def initialize(config = {}, logger = nil)
      @config = config
      @logger = logger

      schema_json = File.read(File.expand_path(AVRO_SCHEMA_FILE, __FILE__)).strip
      @schema_id = get_schema_id schema_json
      @schema = Avro::Schema.parse schema_json
    end

    def encode(event)
      dw = Avro::IO::DatumWriter.new(@schema)
      buffer = StringIO.new
      buffer.write(MAGIC_BYTE.chr)
      buffer.write([@schema_id].pack('I>'))
      encoder = Avro::IO::BinaryEncoder.new(buffer)
      dw.write(event, encoder)
      buffer.string.to_java_bytes
    end

    private

    def get_schema_id(schema_json)
      endpoint = @config.fetch :schema_registry_endpoint, 'http://schema-registry.localhost:8081'
      username = @config.fetch :schema_registry_username, nil
      password = @config.fetch :schema_registry_password, nil
      client = SchemaRegistry::Client.new(endpoint, username, password)

      subject_name = @config.fetch :schema_registry_subject_name, 'killbill-notify-value'
      subject = client.subject(subject_name)
      subject.register_schema(schema_json) unless subject.schema_registered?(schema_json)

      schema = subject.verify_schema(schema_json)
      schema.id
    end

  end
end