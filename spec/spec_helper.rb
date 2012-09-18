$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'rspec'
require 'active_support/all'
require 'active_record'
require "serial_preference/version"
require 'serial_preference/preference_definition'
require "serial_preference/preferenzer"
require "serial_preference/has_preference_map"


RSpec.configure do |config|
end