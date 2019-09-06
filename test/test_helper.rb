require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
end
require "minitest"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# require_relative your lib files here!
require_relative '../lib/room'
require_relative '../lib/date_range'
require_relative '../lib/single_res'
require_relative '../lib/block_res'
require_relative '../lib/booking_manager'
