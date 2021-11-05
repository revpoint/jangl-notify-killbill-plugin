require 'spec_helper'
require 'logger'

require 'jangl_notify'

describe JanglNotify::NotificationPlugin do

  before(:each) do
    kb_apis = Killbill::Plugin::KillbillApi.new("killbill-jangl-notify", {})

    @plugin         = JanglNotify::NotificationPlugin.new
    @plugin.logger  = Logger.new(STDOUT)
    @plugin.kb_apis = kb_apis

    @kb_event             = Killbill::Plugin::Model::ExtBusEvent.new
    @kb_event.event_type  = :INVOICE_CREATION
    @kb_event.object_type = :INVOICE
    @kb_event.object_id   = "9f73c8e9-188a-4603-a3ba-2ce684411fb9"
    @kb_event.account_id  = "a86ed6d4-c0bd-4a44-b49a-5ec29c3b314a"
    @kb_event.tenant_id   = "b86fd6d4-c0bd-4a44-b49a-5ec29c3b3765"

    @plugin.start_plugin
  end

  after(:each) do
    @plugin.stop_plugin
  end

  it "should start and stop correctly" do
  end

  it "should should test receiving an event" do
    output = @plugin.on_event(@kb_event)
    output.should be_nil
  end
end