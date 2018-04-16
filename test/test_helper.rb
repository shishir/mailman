require 'minitest/autorun'
require 'rack/test'

ENV['MAILMAN_ENV'] = "test"
require_relative('../api.rb')
