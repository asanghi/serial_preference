$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'rspec'
require 'active_support'
require 'serial_preference/preference'
require 'serial_preference/preference_group'
require 'serial_preference'
require 'active_record'

RSpec.configure do |config|
  config.before(:each) do
    @instance = @preferenzer = SerialPreference::Preferenzer.instance.tap do |i|
      i.total_reset
    end
  end

end